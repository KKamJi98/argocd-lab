#!/bin/bash

aws eks update-kubeconfig --region ap-northeast-2 --name kkamji-al2023-prod --alias kkamji-al2023-prod
argocd login argocd.kkamji.net --username admin --grpc-web
argocd cluster add kkamji-al2023-prod --name kkamji-al2023-prod