
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
    
    
  }

  
  backend "azurerm" {
    resource_group_name = "RG-TF-01"
    storage_account_name = "storagetf01"
    container_name = "tfstate"
    key = "rg-dev.tfstate"
    subscription_id = "b35cb4f2-8acb-4824-94c7-4e7aa56f4e47" 
    client_id = ""
    client_secret = ""
    tenant_id = ""
  }

}


provider "azurerm" {
    subscription_id = "b35cb4f2-8acb-4824-94c7-4e7aa56f4e47" 
    client_id = ""
    client_secret = ""
    tenant_id = ""
    
    features {}
}
            
resource "azurerm_resource_group" "rg-dev" {
    name     = "rg-dev"
    location = "East US"
    
    tags = {


    }
            
}

                
resource "azurerm_virtual_network" "vnet-dev" {
    name                = "vnet-dev"
    resource_group_name = azurerm_resource_group.rg-dev.name
    address_space       =  ["10.2.0.0/16"]
    location            = "East US"   
    
    
    tags = {


    }
            
    
}


resource "azurerm_subnet" "vnet-dev-subnet-dev" {
    name                 = "subnet-dev"
    resource_group_name  = azurerm_resource_group.rg-dev.name
    virtual_network_name = azurerm_virtual_network.vnet-dev.name
    address_prefixes       = ["10.2.0.0/24"]
    
    
   
}
 
 

                
resource "azurerm_network_interface" "nicvm-dev-01" {
    name                = "nicvm-dev-01"
    location            = "East US"
    resource_group_name = azurerm_resource_group.rg-dev.name
    
    ip_configuration {
        primary = true
        name = "ipconfig1"
        subnet_id = azurerm_subnet.vnet-dev-subnet-dev.id
        private_ip_address_allocation = "Static"
        private_ip_address  = "10.2.0.5"
        
    }
}

                    
resource "azurerm_virtual_machine" "vm-dev-01" {
    name                  = "vm-dev-01"
    location              = "East US"
    
    resource_group_name   = azurerm_resource_group.rg-dev.name
    primary_network_interface_id = azurerm_network_interface.nicvm-dev-01.id
    network_interface_ids = ["${azurerm_network_interface.nicvm-dev-01.id}"]
    vm_size               = "Standard_B1s"

    # Uncomment this line to delete the OS disk automatically when deleting the VM
    # delete_os_disk_on_termination = true

    # Uncomment this line to delete the data disks automatically when deleting the VM
    # delete_data_disks_on_termination = true

    

    
    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
    }


    
    tags = {


    }
            


    storage_os_disk {
        name              = "vm-dev-01-osdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }


   os_profile {
        computer_name  = "vm-dev-01"
        admin_username = "stuart"
        admin_password = data.azurerm_key_vault_secret.stuart.value
    }
                    

    os_profile_windows_config {
        provision_vm_agent = true
    }

	depends_on = []
}
resource "azurerm_virtual_machine_extension" "vm-dev-01antimalwareExtension" {
    name                 = "vm-dev-01antimalwareExtension"
    virtual_machine_id = azurerm_virtual_machine.vm-dev-01.id
    publisher            = "Microsoft.Azure.Security"
    type                 = "IaaSAntimalware"
    type_handler_version = "1.3"
    auto_upgrade_minor_version = "true"
    
    settings = <<SETTINGS
    {
        "AntimalwareEnabled": "true",
        "Exclusions": {
            "Paths": "C:\\Users",
            "Extensions": ".txt",
            "Processes": "taskmgr.exe"
        },
        "RealtimeProtectionEnabled": "true",
        "ScheduledScanSettings": {
            "isEnabled": "true",
            "scanType": "Quick",
            "day": "7",
            "time": "120"
        }
    }
SETTINGS

    
}            
             
            
                
resource "azurerm_network_interface" "nicvm-dev-02" {
    name                = "nicvm-dev-02"
    location            = "East US"
    resource_group_name = azurerm_resource_group.rg-dev.name
    
    ip_configuration {
        primary = true
        name = "ipconfig1"
        subnet_id = azurerm_subnet.vnet-dev-subnet-dev.id
        private_ip_address_allocation = "Static"
        private_ip_address  = "10.2.0.6"
        
    }
}

                    
resource "azurerm_virtual_machine" "vm-dev-02" {
    name                  = "vm-dev-02"
    location              = "East US"
    
    resource_group_name   = azurerm_resource_group.rg-dev.name
    primary_network_interface_id = azurerm_network_interface.nicvm-dev-02.id
    network_interface_ids = ["${azurerm_network_interface.nicvm-dev-02.id}"]
    vm_size               = "Standard_B1s"

    # Uncomment this line to delete the OS disk automatically when deleting the VM
    # delete_os_disk_on_termination = true

    # Uncomment this line to delete the data disks automatically when deleting the VM
    # delete_data_disks_on_termination = true

    

    
    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
    }


    
    tags = {


    }
            


    storage_os_disk {
        name              = "vm-dev-02-osdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }


   os_profile {
        computer_name  = "vm-dev-02"
        admin_username = "stuart"
        admin_password = data.azurerm_key_vault_secret.stuart.value
    }
                    

    os_profile_windows_config {
        provision_vm_agent = true
    }

	depends_on = []
}
resource "azurerm_virtual_machine_extension" "vm-dev-02antimalwareExtension" {
    name                 = "vm-dev-02antimalwareExtension"
    virtual_machine_id = azurerm_virtual_machine.vm-dev-02.id
    publisher            = "Microsoft.Azure.Security"
    type                 = "IaaSAntimalware"
    type_handler_version = "1.3"
    auto_upgrade_minor_version = "true"
    
    settings = <<SETTINGS
    {
        "AntimalwareEnabled": "true",
        "Exclusions": {
            "Paths": "C:\\Users",
            "Extensions": ".txt",
            "Processes": "taskmgr.exe"
        },
        "RealtimeProtectionEnabled": "true",
        "ScheduledScanSettings": {
            "isEnabled": "true",
            "scanType": "Quick",
            "day": "7",
            "time": "120"
        }
    }
SETTINGS

    
}            
             
            

resource "azurerm_storage_account" "storagespoelabdev01" {
    name                = "storagespoelabdev01"
    resource_group_name = azurerm_resource_group.rg-dev.name
    location     = "East US"
    account_replication_type = "LRS"
    account_tier = "Standard"
    account_kind = "StorageV2"
    is_hns_enabled = false
    
    
    tags = {


    }
            

}
      
resource "azurerm_recovery_services_vault" "rsv-dev-01" {
    name                = "rsv-dev-01"
    location            = "East US"
    resource_group_name = azurerm_resource_group.rg-dev.name
    sku                 = "Standard"
    
    identity {
        type = "SystemAssigned"                   
    }


    
    tags = {


    }
            
}

data "azurerm_key_vault_secret" "stuart" {
    name         = "stuart"
    key_vault_id =  "/subscriptions/b35cb4f2-8acb-4824-94c7-4e7aa56f4e47/resourceGroups/RG-Core/providers/Microsoft.KeyVault/vaults/Core-Lab-KV-01"
}
