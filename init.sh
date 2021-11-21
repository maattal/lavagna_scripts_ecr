# !/bin/bash
cd project
docker build -t lavagna_app_malki:latest .
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/c7o8u9c1
docker tag lavagna_app_malki:latest public.ecr.aws/c7o8u9c1/lavagna_app_malki:$1
docker push public.ecr.aws/c7o8u9c1/lavagna_app_malki:$1
tar -cv -f lavagna-package_$1.tar.gz ./docker-compose.yml ./src/main/webapp ./nginx.conf 
scp -i /home/malki/devleap_scripts/aws_devleap/lavagna.pem -r /home/malki/devleap_scripts/lavagna/malki_attal/lavagna/project/lavagna-package_$1.tar.gz ubuntu@ec2-3-15-27-217.us-east-2.compute.amazonaws.com:~/
ssh -i /home/malki/devleap_scripts/aws_devleap/lavagna.pem ubuntu@ec2-3-15-27-217.us-east-2.compute.amazonaws.com "tar -xf lavagna-package_$1.tar.gz && rm lavagna-package_$1.tar.gz   && echo v=$1 >> .env && sudo docker-compose up --build "

#copy not wotking
#scp -i path/to/key -r path/to/lavagnadir ubuntu@ec2-ip.us-east-2.amazonaws.com:/path/to/dir
#"tar -xf lavagna-package_$1.tar.gz && rm lavagna-package_$1.tar.gz && v=$1 sudo docker-compose up --build "
#if its works . zip it 
#rds