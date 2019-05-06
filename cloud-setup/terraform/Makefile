
TF_OPTIONS=-var-file secrets.tfvars

.PHONY: output

plan:
	terraform plan -var-file secrets.tfvars

apply:
	terraform apply -var-file secrets.tfvars

output:
	mkdir -p _output
	@#terraform output kubeconfig-alpha > _output/kubeconfig-alpha
	terraform output kubeconfig-admin > _output/kubeconfig-admin
	terraform output kubeconfig-tokens > _output/kubeconfig-tokens


