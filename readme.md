# Usage 

```shell
tag=datakit-init:v1.0.1
docker build -t $tag .
docker push $tag
```

# Example

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: daemonset-datakit
  name: datakit-monitor
  namespace: datakit-monitor
spec:
  selector:
    matchLabels:
      app: daemonset-datakit
  template:
    metadata:
      labels:
        app: daemonset-datakit
    spec:
      affinity: {}
      containers:
      - env:
        - name: ENV_DATAWAY
          value: https://openway.dataflux.cn?token=tkn_xxxxxxxxxxxxxxxxxxxxxxx
        - name: ENV_ENABLE_ELECTION
          value: enabled
        - name: ENV_DEFAULT_ENABLED_INPUTS
          value: cpu,disk,diskio,mem,swap,system,hostobject,net,host_processes,kubernetes,container
        - name: ENV_GLOBAL_TAGS
          value: host=__datakit_hostname
        - name: ENV_HTTP_LISTEN
          value: 0.0.0.0:9529
        - name: ENV_LOG_LEVEL
          value: info
        - name: ENV_NAMESPACE
          value: namespace1
        - name: ENV_RUM_ORIGIN_IP_HEADER
          value: X-Forwarded-For
        - name: TZ
          value: Asia/Shanghai
        - name: HOSTIP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.hostIP
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        - name: ENV_IPDB
          value: iploc
        image: pubrepo.jiagouyun.com/datakit/datakit:1.2.11
        imagePullPolicy: IfNotPresent
        name: datakit
        ports:
        - containerPort: 9529
          hostPort: 9529
          name: port
          protocol: TCP
        resources:
          limits:
            cpu: 500m
            memory: 512Mi
          requests:
            cpu: 100m
            memory: 128Mi
        securityContext:
          privileged: true
        volumeMounts:
        - mountPath: /etc/localtime
          name: tz-config
          readOnly: true
        - mountPath: /var/run/docker.sock
          name: docker-socket
          readOnly: true
        - mountPath: /host/proc
          name: proc
          readOnly: true
        - mountPath: /host/dev
          name: dev
          readOnly: true
        - mountPath: /host/sys
          name: sys
          readOnly: true
        - mountPath: /rootfs
          name: rootfs
        - mountPath: /usr/local/datakit/conf.d/container/container.conf
          name: datakit-monitor-conf
          subPath: container.conf
        - mountPath: /usr/local/datakit/conf.d/kubernetes/kubernetes.conf
          name: datakit-monitor-conf
          subPath: kubernetes.conf
        - mountPath: /usr/local/datakit/data/ipdb/iploc
          name: datakit-plugins
          subPath: ipdb/iploc/
        workingDir: /usr/local/datakit
      dnsPolicy: ClusterFirst
      hostIPC: true
      hostNetwork: true
      hostPID: true
      initContainers:
      - args:
        - --ipdb
        - iploc
        image: datakit-init:v1.0.1
        imagePullPolicy: IfNotPresent
        name: datakit-plugins-init
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /shared/datakit/
          name: datakit-plugins
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: datakit-monitor
      serviceAccountName: datakit-monitor
      terminationGracePeriodSeconds: 30
      volumes:
      - hostPath:
          path: /etc/localtime
          type: ""
        name: tz-config
      - configMap:
          defaultMode: 420
          name: datakit-monitor-conf
        name: datakit-monitor-conf
      - hostPath:
          path: /var/run/docker.sock
          type: ""
        name: docker-socket
      - hostPath:
          path: /proc
          type: ""
        name: proc
      - hostPath:
          path: /dev
          type: ""
        name: dev
      - hostPath:
          path: /sys
          type: ""
        name: sys
      - hostPath:
          path: /
          type: ""
        name: rootfs
      - emptyDir: {}
        name: datakit-plugins

```
