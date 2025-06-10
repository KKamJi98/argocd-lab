#!/bin/bash

aws eks update-kubeconfig --region ap-northeast-2 --name kkamji-al2023 --alias kkamji-al2023
argocd login argocd.kkamji.net --username admin --grpc-web
argocd cluster add kkamji-al2023 --name kkamji-al2023
