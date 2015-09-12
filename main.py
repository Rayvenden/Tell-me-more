import re
import os
import argparse

def bash_users():
    with open('/etc/passwd', 'r') as fobj:
        f = fobj.readlines()
        pattern = '/bash'

        for i in f:
            m = re.search(pattern, i)
            if m:
                print("%s" % i.split(':')[4])
            else:
                pass

def no_bash_users():
    with open('/etc/passwd', 'r') as fobj:
        f = fobj.readlines()
        pattern = '/nologin|/bash'

        for i in f:
            m = re.search(pattern, i)
            if m:
                pass
            else:
                print("%s" % (i.split(':')[4]))

def whoami():
    print("%s" % (os.getlogin()))

def memory_details():
    with open('/proc/meminfo', 'r') as fobj:
        f = fobj.readlines()
        pattern = '^Mem'

        for i in f:
            m = re.search(pattern, i)
            if m:
                print("%s: %d MB" % (i.split(':')[0], int(i.split()[1])/1024))
            else:
                pass


def main():
    parser = argparse.ArgumentParser(description = "Gives information about me")

    group = parser.add_mutually_exclusive_group()
    group.add_argument("-u", "--users", help = "All system users", action = "store_true")
    group.add_argument("-i", "--whoami", help = "Current user who is logged in", action = "store_true")
    group.add_argument("-m", "--mem", help = "Details of memory of the system", action = "store_true")
    group.add_argument("-n", "--nbusers", help = "Users who are not using bash, excluding the accounts with the nologin shell", action = "store_true")

    args = parser.parse_args()

    if args.users:
        return bash_users()
    elif args.nbusers:
        return no_bash_users()
    elif args.whoami:
        return whoami()
    elif args.mem:
        return memory_details()
    else:
        raise argparse.ArgumentTypeError(" Provide an optional argument to get output")

if __name__ == '__main__':
    main() 
