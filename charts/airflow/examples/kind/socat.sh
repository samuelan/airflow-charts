for port in 80 443
do
    node_port=$(kubectl get service -n ingress-nginx ingress-nginx-controller -o=jsonpath="{.spec.ports[?(@.port == ${port})].nodePort}")

    docker run -d --name kind-proxy-${port} \
      --publish 127.0.0.1:${port}:${port} \
      --link samkind-control-plane:target \
      alpine/socat -dd \
      tcp-listen:${port},fork,reuseaddr tcp-connect:target:${node_port}
done