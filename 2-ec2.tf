data "aws_ami" "my_ami" {
     most_recent      = true
     owners           = ["self"]

     filter {
        name   = "name"
        values = ["voting-app-base-*"] 
    }
}


resource "aws_instance" "web-1" {
    count = 3
    #ami = var.imagename
    #ami = "ami-0d857ff0f5fc4e03b"
    ami = "${data.aws_ami.my_ami.id}"
    availability_zone = "ap-south-1a"
    instance_type = "t2.small"
    key_name = "SecOps-Key"
    subnet_id = "${aws_subnet.subnet1-public.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    tags = {
        Name = "VotingApp-Node-${count.index+1}"
        Env = "Prod"
        Owner = "sonal"
	    CostCenter = "ABCD"
    }
}
