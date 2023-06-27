#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
	mkdir .ssh
	echo "Copying the SSH Key Of Jenkins to the server"
	echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZZf8gm2nC9JcCwsRSBG6OA6XEPhIwhjuwHH4IBlAWUBz932lqWFVRBxFPWLi9wgNckqKfTMWjIIwwNZNYvxYMPMTKcP9ibV2nmMkyvAmxZOOniDRwShETO0P/KFa2RZ/MbzuWl9uvHYcJ7TiQ9VCPrPMfEXqyW/6fq7URGlMU+jlUjxL7Hv8ODYPTfHKggP7Mypd0qLgtq+yLd2Fw/tU42nhAjK7EVWd4Hn7CA87oVFpRz3bvD1kOEHXbwK1u9tI2ephc+7tI+qP4kzfj+PYx4ZlQv3Tn9TW2eunaZuF7igzUU5z+PO1dOPy2z9+ryfwSs0KBxOweYYXoGY6aBD2D macmarkdhas.kumaradhas@innovasolutions.com" >> /home/ec2-user/.ssh/authorized_keys
	chmod 700 /home/ec2-user/.ssh
	chmod 600 /home/ec2-user/.ssh/authorized_keys