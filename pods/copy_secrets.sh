#!/bin/bash

kubectl exec -it pod1 -- cp /etc/ipsec.secrets /etc/ipsec.secrets.bkup
kubectl cp ipsec.secrets pod1:/etc/ipsec.secrets

kubectl exec -it pod2 -- cp /etc/ipsec.secrets /etc/ipsec.secrets.bkup
kubectl cp ipsec.secrets pod2:/etc/ipsec.secrets

kubectl exec -it pod1 -- cp /etc/ipsec.conf /etc/ipsec.conf.bkup
kubectl cp ipsec.conf pod1:/etc/ipsec.conf

kubectl exec -it pod2 -- cp /etc/ipsec.conf /etc/ipsec.conf.bkup
kubectl cp ipsec.conf pod2:/etc/ipsec.conf

