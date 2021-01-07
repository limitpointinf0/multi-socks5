// Configure the Google Cloud provider
provider "google" {
    credentials = file(var.creds_path)
    project     = var.project
    region      = var.region
}

// Add Firewall Rule
resource "google_compute_firewall" "dante-fw" {
    name    = "dante"
    network = var.net

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports    = ["1080"]
    }
}


resource "random_id" "instance_id" {
    byte_length = 8
}

// Asia Southeast
resource "google_compute_instance" "ase" {
    name         = "ase-vm-${random_id.instance_id.hex}"
    machine_type = var.size
    zone         = var.zone_ase

    boot_disk {
        initialize_params {
            image = var.image
        }
    }

    metadata = {
        ssh-keys = "chris:${file("~/.ssh/id_rsa.pub")}"
    }

    metadata_startup_script = "${file("init.sh")}"

    network_interface {
        network = var.net

        access_config {}
    }
}

// Asia East
resource "google_compute_instance" "ae" {
    name         = "ae-vm-${random_id.instance_id.hex}"
    machine_type = var.size
    zone         = var.zone_ae

    boot_disk {
        initialize_params {
            image = var.image
        }
    }

    metadata = {
        ssh-keys = "chris:${file("~/.ssh/id_rsa.pub")}"
    }

    metadata_startup_script = "${file("init.sh")}"

    network_interface {
        network = var.net

        // has an external ip
        access_config {}
    }
}

// Asia Northeast
resource "google_compute_instance" "ane" {
    name         = "ane-vm-${random_id.instance_id.hex}"
    machine_type = var.size
    zone         = var.zone_ane

    boot_disk {
        initialize_params {
            image = var.image
        }
    }

    metadata = {
        ssh-keys = "chris:${file("~/.ssh/id_rsa.pub")}"
    }

    metadata_startup_script = "${file("init.sh")}"

    network_interface {
        network = var.net

        // has an external ip
        access_config {}
    }
}

// External IP outputs
output "ase-ip" {
    value = google_compute_instance.ase.network_interface.0.access_config.0.nat_ip
}

output "ae-ip" {
    value = google_compute_instance.ae.network_interface.0.access_config.0.nat_ip
}

output "ane-ip" {
    value = google_compute_instance.ane.network_interface.0.access_config.0.nat_ip
}