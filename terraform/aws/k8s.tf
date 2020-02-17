provider "kubernetes" {
  config_path = "${path.module}/output/kubeconfig"
}

resource "null_resource" "output" {
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/output"
  }
}

resource "local_file" "kubeconfig" {
  filename   = "${path.module}/output/kubeconfig"
  content    = local.kubeconfig
  depends_on = [null_resource.output]
}

resource "null_resource" "push_containers" {

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
find ${path.module}/../../docker -mindepth 1 -type d  -printf '%f\n'| while read container; do
  pushd ${path.module}/../../docker/$container
  cp Dockerfile.template Dockerfile
  sed -i "s/((tezos_sentry_version))/${var.tezos_sentry_version}/" Dockerfile
  sed -i "s/((tezos_private_version))/${var.tezos_private_version}/" Dockerfile
  tag="${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/$container:latest"
  docker build -t $tag .
  docker push $tag
  rm -v Dockerfile
  popd
done
EOF
  }
}

resource "null_resource" "apply" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF

cd ${path.module}/../../tezos-baker/aws/
cat << EOK > kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- tezos-public-node-stateful-set.yaml
- tezos-private-node-deployment.yaml
- tezos-remote-signer-forwarder.yaml

imageTags:
  - name: tezos/tezos
    newTag: ${var.tezos_private_version}
  - name: tezos/tezos-public
    newName: tezos/tezos
    newTag: ${var.tezos_sentry_version}
  - name: tezos-baker-with-remote-signer
    newName: ${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/tezos-baker-with-remote-signer
    newTag: latest
  - name: tezos-endorser-with-remote-signer
    newName: ${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/tezos-endorser-with-remote-signer
    newTag: latest
  - name: tezos-remote-signer-forwarder
    newName: ${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/tezos-remote-signer-forwarder
    newTag: latest
  - name: tezos-remote-signer-loadbalancer
    newName: ${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/tezos-remote-signer-loadbalancer
    newTag: latest
  - name: tezos-snapshot-downloader
    newName: ${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/tezos-snapshot-downloader
    newTag: latest
  - name: tezos-archive-downloader
    newName: ${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/tezos-archive-downloader
    newTag: latest
  - name: tezos-key-importer
    newName: ${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/tezos-key-importer
    newTag: latest
  - name: tezos-private-node-connectivity-checker
    newName: ${var.aws-account-id}.dkr.ecr.us-west-2.amazonaws.com/tezos-private-node-connectivity-checker
    newTag: latest

configMapGenerator:
- name: tezos-configmap
  literals:
  - ROLLING_SNAPSHOT_URL="${var.rolling_snapshot_url}"
  - FULL_SNAPSHOT_URL="${var.full_snapshot_url}"
  - PUBLIC_BAKING_KEY="${var.public_baking_key}"
  - NODE_HOST="localhost"
  - PROTOCOL="${var.protocol}"
  - PROTOCOL_SHORT="${var.protocol_short}"
  - DATA_DIR=/var/run/tezos
- name: remote-signer-forwarder-configmap
  literals:
  - AUTHORIZED_SIGNER_KEY_A="${var.authorized_signer_key_a}"
  - AUTHORIZED_SIGNER_KEY_B="${var.authorized_signer_key_b}"
EOK
kubectl --kubeconfig ${path.module}/../../terraform/aws/output/kubeconfig apply -k .
EOF

  }
  depends_on = [null_resource.push_containers]
}

#resource "null_resource" "apply_alb" {
#  provisioner "local-exec" {
#    interpreter = ["/bin/bash", "-c"]
#    command     = <<EOF
#kubectl --kubeconfig ${path.module}/output/kubeconfig apply -f alb/rbac-role.yaml -f alb/alb-ingress-controller.yaml
#kubectl --kubeconfig ${path.module}/output/kubeconfig annotate serviceaccount -n kube-system alb-ingress-controller \
#"eks.amazonaws.com/role-arn=${iam_policy_role.alb_role.arn}"
#EOF
#}
#    depends_on = [null_resource.apply]
#}
