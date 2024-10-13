## env

ubuntu@ubuntu:/code$ uname -a
Linux ubuntu 6.8.0-45-generic #45-Ubuntu SMP PREEMPT_DYNAMIC Fri Aug 30 12:26:41 UTC 2024 aarch64 aarch64 aarch64 GNU/Linux
ubuntu@ubuntu:/code$ cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.1 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo

## problem

ubuntu@ubuntu:/code$ ls
test.c
ubuntu@ubuntu:/code$ clang -S -emit-llvm test.c
ubuntu@ubuntu:/code$ ls
test.c  test.ll
ubuntu@ubuntu:/code$ opt -dot-cfg test.ll
opt: Unknown command line argument '-dot-cfg'.  Try: 'opt --help'
opt: Did you mean '--dot-dom'?
