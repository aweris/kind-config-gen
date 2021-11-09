package kind

import (
	"sigs.k8s.io/kind/pkg/apis/config/v1alpha4"
	"sigs.k8s.io/kind/pkg/apis/config/defaults"
)

v1alpha4.#Cluster & {
	_Values: {
		name:              string
		image:             string | *defaults.#Image  @tag(image,type=string)
		disableDefaultCNI: bool | *true               @tag(disableDefaultCNI,type=bool)
		podSubnet:         string | *"192.168.0.0/16" @tag(podSubnet,type=bool) // set to Calico's default subnet by default

		dockerUsername: string | *"" @tag(dockerUsername,type=string)
		dockerPassword: string | *"" @tag(dockerPassword,type=string)
		dockerMirror:   string | *"" @tag(dockerMirror,type=string)
	}

	v1alpha4.#TypeMeta & {
		kind:       "Cluster"
		apiVersion: "kind.x-k8s.io/v1alpha4"
	}

	networking: {
		disableDefaultCNI: _Values.disableDefaultCNI
		podSubnet:         _Values.podSubnet
	}

	containerdConfigPatches: [
		if _Values.dockerUsername != "" && _Values.dockerPassword != "" {
			"""
    [plugins."io.containerd.grpc.v1.cri".registry.configs."registry-1.docker.io".auth]
      username = \( _Values.dockerUsername )
      password = \( _Values.dockerPassword )
      auth = ""
      identitytoken = ""
    """
		},
		if _Values.dockerMirror != "" {
			"""
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
      endpoint = ["\( _Values.dockerMirror )"]
    """
		},
	]

	nodes: [
		{
			role:  v1alpha4.#ControlPlaneRole
			image: _Values.image
		},
	]
}
