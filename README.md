# NAT_Simple_Exam
A simple NAT example based on topics [Netruon 理解（11）：使用 NAT 将 Linux network namespace 连接外网](https://www.cnblogs.com/sammyliu/p/5760125.html)
## How to use
- Simply run `make create_nat` to generate a netns named "myspace" with NAT rules are properly set.
- Run `make test_nat` to do a simple wget test.
  You might also want to capture the process with wireshark using the following commands:
  ```shell
  $ tcpdump -i veth1 -p tcp -env
  $ tcpdump -i eth0 -p tcp -env
  ```
- Run `make clean_nat` to do the house cleaning jobs.

N.B. You might need supervisor permission to execute these commands.
