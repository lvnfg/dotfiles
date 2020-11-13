function getPublicIP() {
    publicIP="$(curl ipecho.net/plain)"
    echo $publicIP
}
