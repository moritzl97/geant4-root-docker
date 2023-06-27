## Field files

This folder contains field map files to be used with the UI commands:

- /setup/setCavityFieldFile <FIELDFILE>
- /setup/cusp/setCuspElAsciiFile <FIELDFILE>
- /setup/cusp/setCuspMagAsciiFile <FIELDFILE>

See some usage examples in macrobase.

## Copy/sync files

Your local folder should have been synchronized with the one in the ASACUSA EOS space once when the autoinstall.sh script was run. 

In order do the sync again, use:

```bash
rsync -avz <YOUR_CERN_USERNAME>@lxplus.cern.ch:/eos/experiment/asacusa/hbar-g4-gshfs_files/fields hbar_gshfs_FTF/
```
