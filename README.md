# Aayush-Tiwari-aws-assessment
this repository contain aws  technical assessments
# Ques 1
## Brief Explanation of Approach
To guarantee high availability, I created a Virtual Private Cloud (VPC) that spans two Availability Zones (us-east-1a and us-east-1b). I put my plan into action by putting backend resources in private subnets and web-facing resources in public subnets with direct Internet Gateway access. A NAT gateway in the first public subnet securely controls outbound internet access for the private subnets.
## CIDR Ranges & Justification
VPC CIDR (10.0.0.0/16): I chose a /16 block because it provides 65,536 IP addresses, offering  scalability without risk of IP exhaustion. It is a standard private IP range.

Subnet CIDRs (10.0.1.0/24 to 10.0.4.0/24): I allocated /24 blocks (256 IPs each) for the subnets. This is a standard practice as it is easy to read (segmenting by the third octet) and provides sufficient addresses for typical application workloads while leaving the rest of the VPC space available for future expansion.
## images
<img width="1915" height="824" alt="Screenshot 2025-12-04 132454" src="https://github.com/user-attachments/assets/2f320038-9017-47a7-a370-52f84a1c7e3c" />
vpc

<img width="1917" height="824" alt="Screenshot 2025-12-04 132608" src="https://github.com/user-attachments/assets/a1903708-a2ef-4964-92fc-df2b8407fdcb" />
subnets

<img width="1917" height="819" alt="Screenshot 2025-12-04 132648" src="https://github.com/user-attachments/assets/1959fe9f-2303-4361-91ea-4a32be6ccabe" />
nat gateway

<img width="1903" height="825" alt="Screenshot 2025-12-04 132750" src="https://github.com/user-attachments/assets/bf9844fd-d53b-4da2-b917-e459e86b77e2" />
route tables

<img width="1919" height="815" alt="Screenshot 2025-12-04 132812" src="https://github.com/user-attachments/assets/1b320ac5-f918-489c-93e2-718863957ed3" />
igw

# Ques2

## Approach & Hardening
 
* I deployed an EC2 instance in the public subnet created in the previous stage.

* Nginx Installation: I employed EC2 user_data to script the installation of Nginx and build a custom index.html file providing the resume details at launch time.

Hardening Techniques:

Only traffic on Port 80 (HTTP) is permitted by the Least Privilege Security Group. SSH (Port 22) is limited to prevent illegal access.

IMDSv2: To prevent SSRF (Server-Side Request Forgery) attacks, I set metadata_options to 
enquire tokens.
## Images
<img width="1912" height="1005" alt="Screenshot 2025-12-04 140504" src="https://github.com/user-attachments/assets/820c15c6-7691-42a0-9d5f-6898dc94ad19" />
websites
<img width="1910" height="816" alt="Screenshot 2025-12-04 141454" src="https://github.com/user-attachments/assets/b22cfabb-a5d3-4e4c-9caa-87a0b6f9abfb" />
EC2-Instance
<img width="1906" height="1071" alt="Screenshot 2025-12-04 141605" src="https://github.com/user-attachments/assets/ee969835-ae8a-4614-8d98-99eecdff3fd7" />
Security Group

# Ques3
## Architecture 

* I implemented a highly available 2-tier architecture.

Traffic Flow: The Application Load Balancer (ALB) in the public subnets receives external traffic. Requests are sent to the Target Group by the ALB.

Private Compute: EC2 instances within Private Subnets are where the real application operates. Because these instances don't have public IPs, security is improved.

## images
<img width="1919" height="941" alt="Screenshot 2025-12-04 150724" src="https://github.com/user-attachments/assets/a2ea4ec6-46ff-4840-9cb1-612859ba6140" />

<img width="1918" height="948" alt="Screenshot 2025-12-04 150935" src="https://github.com/user-attachments/assets/d5b32f8a-d9a0-423c-a110-f6f997f16179" />


<img width="1919" height="946" alt="Screenshot 2025-12-04 151055" src="https://github.com/user-attachments/assets/336d070a-aaa6-4939-8427-1acd0c67f3c4" />

<img width="1912" height="938" alt="Screenshot 2025-12-04 151204" src="https://github.com/user-attachments/assets/ee61df98-d661-4b80-b6d5-e4d5491bc37c" />

<img width="1914" height="943" alt="Screenshot 2025-12-04 151315" src="https://github.com/user-attachments/assets/4fc509b5-a649-407b-84df-09db70e79421" />


# Ques4

## Brief Explanation
Why Cost Monitoring is Important For beginners, cloud costs can be deceptive because resources are billed by the second or hour. Leaving a powerful instance running or forgetting about unattached storage volumes can lead to unexpected bills ranging from hundreds to thousands of dollars. Monitoring ensures you are notified before the budget is blown, not after the invoice arrives.

Common Causes of Sudden Bill Increases

* Forgotten Resources: Leaving EC2 instances or RDS databases running 24/7 when they are not needed.

* Unattached EBS Volumes: Deleting an EC2 instance but forgetting to delete the attached storage volume.

* Elastic IPs: Keeping an Elastic IP reserved but not attached to a running instance (AWS charges for idle static IPs).

* Data Transfer: Unexpected high traffic (outbound data) from a public-facing application.

## images

<img width="1919" height="936" alt="Screenshot 2025-12-04 153937" src="https://github.com/user-attachments/assets/8c8e3a1d-56ab-43a5-a35f-3d5c4f117202" />

# Ques5
## Brief Explanation






