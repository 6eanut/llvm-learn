struct swap_info_struct {
        unsigned long   flags;          /* SWP_USED etc: see above */
        signed short    prio;           /* swap priority of this type */
        struct plist_node list;         /* entry in swap_active_head */
        signed char     type;           /* strange name for an index */
        unsigned int    max;            /* extent of the swap_map */
        unsigned char *swap_map;        /* vmalloc'ed array of usage counts */
        struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
        struct swap_cluster_list free_clusters; /* free clusters list */
        unsigned int lowest_bit;        /* index of first free in swap_map */
        unsigned int highest_bit;       /* index of last free in swap_map */
        unsigned int pages;             /* total of usable pages of swap */
        unsigned int inuse_pages;       /* number of those currently in use */
        unsigned int cluster_next;      /* likely index for next allocation */
        unsigned int cluster_nr;        /* countdown to next cluster search */
        struct percpu_cluster __percpu *percpu_cluster; /* per cpu's swap location */
        struct rb_root swap_extent_root;/* root of the swap extent rbtree */
        struct block_device *bdev;      /* swap device or bdev of swap file */
        struct file *swap_file;         /* seldom referenced */
        unsigned int old_block_size;    /* seldom referenced */
#ifdef CONFIG_FRONTSWAP
        unsigned long *frontswap_map;   /* frontswap in-use, one bit per page */
        atomic_t frontswap_pages;       /* frontswap pages in-use counter */
#endif

static inline void frontswap_init(unsigned type, unsigned long *map)
{
#ifdef CONFIG_FRONTSWAP
        __frontswap_init(type, map);
#endif
}

#ifdef CONFIG_FRONTSWAP
extern struct static_key_false frontswap_enabled_key;

static inline bool frontswap_enabled(void)
{
        return static_branch_unlikely(&frontswap_enabled_key);
}

static inline bool frontswap_test(struct swap_info_struct *sis, pgoff_t offset)
{
        return __frontswap_test(sis, offset);
}

static inline void frontswap_map_set(struct swap_info_struct *p,
                                     unsigned long *map)
{
        p->frontswap_map = map;
}

static inline unsigned long *frontswap_map_get(struct swap_info_struct *p)
{
        return p->frontswap_map;
}
#else
