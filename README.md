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

# ques2

