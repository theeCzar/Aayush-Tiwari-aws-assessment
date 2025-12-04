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
equire tokens.
## Images
<img width="1912" height="1005" alt="Screenshot 2025-12-04 140504" src="https://github.com/user-attachments/assets/820c15c6-7691-42a0-9d5f-6898dc94ad19" />
websites
<img width="1910" height="816" alt="Screenshot 2025-12-04 141454" src="https://github.com/user-attachments/assets/b22cfabb-a5d3-4e4c-9caa-87a0b6f9abfb" />
EC2-Instance
<img width="1906" height="1071" alt="Screenshot 2025-12-04 141605" src="https://github.com/user-attachments/assets/ee969835-ae8a-4614-8d98-99eecdff3fd7" />
Security Group

# Ques3


