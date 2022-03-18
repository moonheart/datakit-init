#!/usr/bin/env bash

set -exuo pipefail

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --ipdb)
      IPDB="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters


if [[ -n "${IPDB}" ]]; then
  if [[ "${IPDB}" == "iploc" ]]; then
    echo "Using iploc database"
    mkdir -p "${SHARED_DIR}/ipdb/iploc/"
    cd "${LOCAL_DIR}/ipdb/iploc"
    tar xzvf "${LOCAL_DIR}/ipdb/iploc/iploc.tar.gz" -C "${SHARED_DIR}/ipdb/iploc/"
  else
    echo "Unknown ipdb type: ${IPDB}"
  fi
fi
