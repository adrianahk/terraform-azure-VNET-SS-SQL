team1: 
		cd VNET && terraform init  && terraform plan  && terraform apply -auto-approve 


team2: 
		cd SS && terraform init  && terraform plan  && terraform apply -auto-approve 

team3: 
		cd SQL && terraform init  && terraform plan  && terraform apply -auto-approve 

final-step: 
		cd VNET && terraform init  && terraform plan  && terraform apply -auto-approve 
		cd SS && terraform init  && terraform plan  && terraform apply -auto-approve 
		cd SQL && terraform init  && terraform plan  && terraform apply -auto-approve 



final-step-destroy: 
		cd VNET && terraform init  && terraform plan  && terraform destroy -auto-approve 
		cd SS && terraform init  && terraform plan  && terraform destroy -auto-approve 
		cd SQL && terraform init  && terraform plan  && terraform destroy -auto-approve 

