# Organization for Samsung SM8650 devices
This organization holds repositories for Samsung devices based on the Qualcomm SM8650 SoC.
* Telegram group: https://t.me/samsung_sm8650

Status:
 * Kernel boots but LineageOS crashes early on due to KeyMint issues. Recovery works. (As of 27-08-2024)

Devices currently in the works:
 * Galaxy S24 Ultra (e3q, SM-S928B)

## Getting started
1. Clone the lineage-21.0 source code by following [this page](https://wiki.lineageos.org/emulator) until the end of the ["Download the source code"](https://wiki.lineageos.org/emulator#download-the-source-code) section
2. Navigate into the root directory of the lineage-21.0 source code
3. Run this script:
    ```
    $ curl https://raw.githubusercontent.com/samsung-sm8650/.github/main/samsung-sm8650-prepare.sh | bash
    ```
4. Download the latest dump into ~/Downloads or some other directory:
    ```
    $ git clone https://dumps.tadiphone.dev/dumps/samsung/e3q.git --single-branch --branch e3qxxx-user-14-UP1A.231005.007-S928BXXS3AXGF-release-keys ~/Downloads/e3q-dump
    ```
5. Extract vendor files:
    ```
    $ ./device/samsung/e3q/extract-files.sh ~/Downloads/e3q-dump
    ```
