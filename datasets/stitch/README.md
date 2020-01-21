## Template transformation

Download files to convert

```bash
docker run -it -v $PATH_TO_GIT_DIR/d2s-transform-template:/srv \
  -v /data/d2s-workspace:/data \
  umids/d2s-bash-exec:latest \
  /srv/datasets/stitch/download/download.sh input/stitch
```

> Change `$PATH_TO_GIT_DIR` to your git `d2s-transform-template` repository.

> Downloaded files in `/data/d2s-workspace/input/stitch`

Run workflow to convert CSV

```bash
cwl-runner --custom-net d2s-cwl-workflows_network \
  --outdir /data/d2s-workspace/output \
  --tmp-outdir-prefix=/data/d2s-workspace/output/tmp-outdir/ \
  --tmpdir-prefix=/data/d2s-workspace/output/tmp-outdir/tmp- \
  d2s-cwl-workflows/workflows/workflow-csv.cwl \
  datasets/stitch/config-transform-csv-stitch.yml
```