#!/usr/bin/python
from requests import patch

# Settings -> Developer settings -> Personal access tokens ->
# Generate new token (classic) -> Select "repo" -> Generate token
TOKEN = ''
OWNER = 'samsung-sm8650'
REPOS = {
    'lineage-22.1': [
        'android_device_samsung_e3q',
        'android_hardware_qcom-caf_common',
        'android_hardware_samsung',
        'android_kernel_samsung_sm8650',
        'android_kernel_samsung_sm8650-devicetrees',
        'android_kernel_samsung_sm8650-modules'
    ],
    'lineage-22.1-caf-sm8650': [
        'android_device_qcom_sepolicy_vndr',
        'android_hardware_qcom_audio-ar',
        'android_hardware_qcom_display',
        'android_hardware_qcom_media',
        'android_vendor_qcom_opensource_agm',
        'android_vendor_qcom_opensource_arpal-lx',
        'android_vendor_qcom_opensource_dataipa',
        'android_vendor_qcom_opensource_data-ipa-cfg-mgr'
    ]
}

headers = {
    'Accept': 'application/vnd.github+json',
    'Authorization': f'Bearer {TOKEN}',
    'X-GitHub-Api-Version': '2022-11-28',
    'Content-Type': 'application/x-www-form-urlencoded',
}
for branch in REPOS:
    data = f'{{"default_branch": "{branch}"}}'
    print(f'Changing default branch to {branch} for:')
    for repo in REPOS[branch]:
        print(f'{repo}')
        patch(f'https://api.github.com/repos/{OWNER}/{repo}', headers=headers, data=data)
