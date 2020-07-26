# -----------------------------------------------------------------------------
# LVF-DEV PROJECT
# -----------------------------------------------------------------------------
gcloud projects create lvf-dev --name="lvf-dev" --set-as-default
gcloud billing projects link lvf-dev --billing-account 0184BB-A2AA63-01982E

    # TODO: cli to add project-wide ssh keys metadata to project
    # remember to change this 

    # vmdev
    # ------------------------------
    # create service account for vmdev
    gcloud iam service-accounts create vmdev-sa --description="vmdev service account"
    # reserve static ip address for vmdev
    gcloud compute addresses create vmdev-ip --project=lvf-dev --region=asia-southeast1
    # create vmdev instance
    gcloud compute instances create vmdev
        --project=lvf-dev
        --zone=asia-southeast1-b 
        --machine-type=e2-standard-2 
        --subnet=default 
        --address=35.240.193.112 
        --network-tier=PREMIUM 
        --metadata=block-project-ssh-keys=false,ssh-keys=[id_rsa.pub]
        --maintenance-policy=MIGRATE 
        --service-account=vmdev-sa@lvf-project-one.iam.gserviceaccount.com 
        --scopes=https://www.googleapis.com/auth/cloud-platform 
        --image=debian-10-buster-v20200714 
        --image-project=debian-cloud 
        --boot-disk-size=10GB 
        --boot-disk-type=pd-ssd 
        --boot-disk-device-name=vmdev 
        --shielded-secure-boot 
        --shielded-vtpm 
        --shielded-integrity-monitoring 
        --reservation-affinity=any
    # create vmdev's fresh os snapshot
    gcloud compute disks snapshot vmdev 
        --project=lvf-dev
        --snapshot-names=vmdev-fresh 
        --storage-location=asia
        --zone=asia-southeast1-b

    # postgresql-dev
    # ------------------------------
    # TODO: cli to create database

    # secrets
    # postgres-vmdev role
    gcloud secrets create postgresql-atm-postgres-vmdev --replication-policy="automatic"
    gcloud secrets versions add postgres-vmdev --data-file="/path/to/file.txt"  # do not include secret directly in command as plaintext will appear in shell history