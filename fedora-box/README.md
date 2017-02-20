### Building

```bash
docker build -t fedora-box .
```

### Running

```bash
docker run -t -i -p 8080:8080 -p 61616:61616 fedora-box
```

#### Pro tip
You can build images with slightly different criteria - such as an old or new version
of Fedora - and name the image differently. Say "fedora-image-47" for FCREPO4.7  
