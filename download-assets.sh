#!/usr/bin/env bash

# iploc 下载
mkdir -p "${LOCAL_DIR}/ipdb/iploc"
cd "${LOCAL_DIR}/ipdb/iploc"
wget https://zhuyun-static-files-production.oss-cn-hangzhou.aliyuncs.com/datakit/ipdb/iploc.tar.gz
