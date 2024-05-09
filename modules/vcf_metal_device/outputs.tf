output "device_name" {
    description = "Name of the Metal device"
    value = equinix_metal_device.esx.hostname
}

output "vmk0_ip" {
    description = "IP Address set on vmk0"
    value = var.esxi_ip  
}

output "device_id" {
    description = "Metal Device ID"
    value = equinix_metal_device.esx.id
}