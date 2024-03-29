1. Here I used ECS container with task role of s3 rds and cloudwatch which is in under one role name s3-rds-cloudwatch role. Here s3 role only used for this POC but 3 can be used. (RDS must be with password and should not role base as per my understanding and RDS should use with AWS secrete manger to roate password. Here I used simple password in this POC and Role can be used also.)

2. Execution role for ecs is cloudwatch to log container logs in cloudwatch logroup

3. s3-rds-cloudwatch role is used for s3 permission acl. Here we can remove other two roles like rds and cloudwatch which not relevant but for POC I used it in one


4. RDS is under private subnet. multi az disable for now but can enable it

5. ECS container amitdhanani/bitnami_wordpress:latest is my custom image more info at https://github.com/amitdhanani2012/amitdhanani_bitnami_wordpress.git This container image is made from bitnami/wordpress image, I did not use persistent storage for this POC but used container file /download-extra.sh to install s3-uploads wp offload plugin.  We can use /download-extra.sh for any plugin install during container start instead persistent storage, rest depends on plugin type.

6. ECS container runs in public subnet. We can use private subnet for container using load balancer and for that just need to change ecs.tf .  Load Balancer with Autoscaling is already set in alb.tf

7. When you run "terraform apply" you need to supply "AWS  account id, access key, secret, and "s3 bucket name to create s3 bucket" " and email address for wordpress.


8. You can change subnet values, s3 bucketnd other password thing in variables.tf

8. After "terraform apply" complete check load balancer dns address from "lb_dns" output and use port 8080 to see wordpress  and wp-admin 

9. For Default password check variables.tf and also change region,subnet,etc in variable.tf 
 


