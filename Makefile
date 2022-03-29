team1: 
		cd team1 && terraform init  && terraform plan  && terraform apply -auto-approve 


team2: 
		cd team2 && terraform init  && terraform plan  && terraform apply -auto-approve 

team3: 
		cd team3 && terraform init  && terraform plan  && terraform apply -auto-approve 

final-step: 
		cd team1 && terraform init  && terraform plan  && terraform apply -auto-approve 
		cd team2 && terraform init  && terraform plan  && terraform apply -auto-approve 
		cd team3 && terraform init  && terraform plan  && terraform apply -auto-approve 



final-step-destroy: 
		cd team1 && terraform init  && terraform plan  && terraform destroy -auto-approve 
		cd team2 && terraform init  && terraform plan  && terraform destroy -auto-approve 
		cd team3 && terraform init  && terraform plan  && terraform destroy -auto-approve 

