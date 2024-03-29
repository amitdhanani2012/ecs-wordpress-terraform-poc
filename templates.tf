resource "template_file" "wp-container" {
  template = file("task-definitions/wordpress.json")

  vars = {
    s3bucket    = var.s3bucket
    accountid   = var.accountid
    region      = var.region
    db_host     = aws_db_instance.wordpress.address
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
    wp_user     = var.wp_user
    wp_password = var.wp_password
    wp_mail     = var.wp_mail
  }
}
