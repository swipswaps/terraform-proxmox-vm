resource "proxmox_vm_qemu" "vm_qemu" {
  count = "1"

  name        = var.name
  target_node = var.target_node
  vmid        = var.vmid
  desc        = var.desc

  bios     = var.bios
  onboot   = var.onboot
  boot     = var.boot
  bootdisk = var.bootdisk

  agent = var.agent
  iso   = var.iso

  clone      = var.clone
  full_clone = var.full_clone

  hastate = var.hastate
  qemu_os = var.qemu_os

  memory  = var.memory
  balloon = var.balloon
  cores   = var.cores
  sockets = var.sockets
  vcpus   = var.vcpus
  cpu     = var.cpu

  numa    = var.numa
  hotplug = var.hotplug
  scsihw  = var.scsihw

  pool         = var.pool
  force_create = var.force_create
  clone_wait   = var.clone_wait
  preprovision = var.preprovision

  os_type = var.os_type

  dynamic "vga" {
    for_each = var.vga == null ? [] : list(var.vga)
    content {
      type   = vga.value.type
      memory = vga.value.memory
    }
  }

  dynamic "network" {
    for_each = var.vm_network
    content {
      model     = network.value.model
      macaddr   = network.value.macaddr
      bridge    = network.value.bridge
      tag       = network.value.tag
      firewall  = network.value.firewall
      rate      = network.value.rate
      queues    = network.value.queues
      link_down = network.value.link_down
    }
  }

  dynamic "disk" {
    for_each = var.vm_disk
    content {
      type         = disk.value.type
      storage      = disk.value.storage
      size         = disk.value.size
      format       = disk.value.format
      cache        = disk.value.cache
      backup       = disk.value.backup
      iothread     = disk.value.iothread
      replicate    = disk.value.replicate
      ssd          = disk.value.ssd
      discard      = disk.value.discard
      mbps         = disk.value.mbps
      mbps_rd      = disk.value.mbps_rd
      mbps_rd_max  = disk.value.mbps_rd_max
      mbps_wr      = disk.value.mbps_wr
      mbps_wr_max  = disk.value.mbps_wr_max
      file = disk.value.file
      media = disk.value.media
      volume = disk.value.volume
      slot = disk.value.slot
    }
  }

  dynamic "serial" {
    for_each = var.serial == null ? [] : list(var.serial)
    content {
      id   = serial.value.id
      type = serial.value.type
    }
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # for Cloud-init Settings.
  ci_wait      = var.ci_wait
  ciuser       = var.ciuser
  cipassword   = var.cipassword
  cicustom     = var.cicustom
  nameserver   = var.nameserver
  searchdomain = var.searchdomain
  ipconfig0    = var.ipconfig0
  ipconfig1    = var.ipconfig1
  ipconfig2    = var.ipconfig2

  sshkeys = <<EOF
        ${var.sshkeys}
        EOF
}

