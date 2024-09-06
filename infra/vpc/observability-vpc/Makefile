# Default value for GRAFANA_FQDN if not set via environment variable
TF_VAR_GRAFANA_FQDN ?= "default.grafana.example.com"

# Paths
HELMFILE_PATH := ./helmfile.yaml

# Targets
.PHONY: deploy-full-stack deploy-logging deploy-metrics destroy

all: deploy-full-stack

# Helper function to change installed: true/false dynamically in helmfile
define set_installed_flag
	@sed -i.bak 's/\(name: $(1).*installed: \)\(true\|false\)/\1$(2)/' $(HELMFILE_PATH)
endef

deploy-full-stack:
	@echo "Deploying full stack with Grafana FQDN: $(TF_VAR_GRAFANA_FQDN)"
	$(call set_installed_flag,loki,true)
	$(call set_installed_flag,promtail,true)
	$(call set_installed_flag,grafana,true)
	$(call set_installed_flag,prometheus-community,true)

deploy-logging:
	@echo "Deploying logging with Grafana FQDN: $(TF_VAR_GRAFANA_FQDN)"
	$(call set_installed_flag,loki,true)
	$(call set_installed_flag,promtail,true)
	$(call set_installed_flag,grafana,true)
	$(call set_installed_flag,prometheus-community,false)

deploy-metrics:
	@echo "Deploying metrics with Grafana FQDN: $(TF_VAR_GRAFANA_FQDN)"
	$(call set_installed_flag,loki,false)
	$(call set_installed_flag,promtail,false)
	$(call set_installed_flag,grafana,true)
	$(call set_installed_flag,prometheus-community,true)

destroy:
	@echo "Destroying resources for Grafana FQDN: $(TF_VAR_GRAFANA_FQDN)"
	helmfile destroy

