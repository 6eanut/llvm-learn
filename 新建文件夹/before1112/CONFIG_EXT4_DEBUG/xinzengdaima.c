#ifdef CONFIG_EXT4_DEBUG
		ext4_warning(inode->i_sb, "Inode (%ld) finished: extent logical block %llu,"
			     " len %u; IO logical block %llu, len %u",
			     inode->i_ino, (unsigned long long)ee_block, ee_len,
			     (unsigned long long)map->m_lblk, map->m_len);
#endif

#ifdef CONFIG_EXT4_DEBUG
ushort ext4_mballoc_debug __read_mostly;

module_param_named(mballoc_debug, ext4_mballoc_debug, ushort, 0644);
MODULE_PARM_DESC(mballoc_debug, "Debugging level for ext4's mballoc");
#endif

#ifdef CONFIG_EXT4_DEBUG
static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
{
	struct super_block *sb = ac->ac_sb;
	ext4_group_t ngroups, i;

	if (!ext4_mballoc_debug ||
	    (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED))
		return;

	ext4_msg(ac->ac_sb, KERN_ERR, "Can't allocate:"
			" Allocation context details:");
	ext4_msg(ac->ac_sb, KERN_ERR, "status %d flags %d",
			ac->ac_status, ac->ac_flags);
	ext4_msg(ac->ac_sb, KERN_ERR, "orig %lu/%lu/%lu@%lu, "
		 	"goal %lu/%lu/%lu@%lu, "
			"best %lu/%lu/%lu@%lu cr %d",
			(unsigned long)ac->ac_o_ex.fe_group,
			(unsigned long)ac->ac_o_ex.fe_start,
			(unsigned long)ac->ac_o_ex.fe_len,
			(unsigned long)ac->ac_o_ex.fe_logical,
			(unsigned long)ac->ac_g_ex.fe_group,
			(unsigned long)ac->ac_g_ex.fe_start,
			(unsigned long)ac->ac_g_ex.fe_len,
			(unsigned long)ac->ac_g_ex.fe_logical,
			(unsigned long)ac->ac_b_ex.fe_group,
			(unsigned long)ac->ac_b_ex.fe_start,
			(unsigned long)ac->ac_b_ex.fe_len,
			(unsigned long)ac->ac_b_ex.fe_logical,
			(int)ac->ac_criteria);
	ext4_msg(ac->ac_sb, KERN_ERR, "%d found", ac->ac_found);
	ext4_msg(ac->ac_sb, KERN_ERR, "groups: ");
	ngroups = ext4_get_groups_count(sb);
	for (i = 0; i < ngroups; i++) {
		struct ext4_group_info *grp = ext4_get_group_info(sb, i);
		struct ext4_prealloc_space *pa;
		ext4_grpblk_t start;
		struct list_head *cur;
		ext4_lock_group(sb, i);
		list_for_each(cur, &grp->bb_prealloc_list) {
			pa = list_entry(cur, struct ext4_prealloc_space,
					pa_group_list);
			spin_lock(&pa->pa_lock);
			ext4_get_group_no_and_offset(sb, pa->pa_pstart,
						     NULL, &start);
			spin_unlock(&pa->pa_lock);
			printk(KERN_ERR "PA:%u:%d:%u \n", i,
			       start, pa->pa_len);
		}
		ext4_unlock_group(sb, i);

		if (grp->bb_free == 0)
			continue;
		printk(KERN_ERR "%u: %d/%d \n",
		       i, grp->bb_free, grp->bb_fragments);
	}
	printk(KERN_ERR "\n");
}
#else

#ifdef CONFIG_EXT4_DEBUG
extern ushort ext4_mballoc_debug;

#define mb_debug(n, fmt, ...)	                                        \
do {									\
	if ((n) <= ext4_mballoc_debug) {				\
		printk(KERN_DEBUG "(%s, %d): %s: " fmt,			\
		       __FILE__, __LINE__, __func__, ##__VA_ARGS__);	\
	}								\
} while (0)
#else