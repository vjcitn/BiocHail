

#https://github.com/hail-is/hail/blob/main/ci/pinned-requirements.txt 62ef
from_pinned = c("certifi==2025.4.26",
"cffi==1.17.1",
"charset-normalizer==3.4.2",
"click==8.1.8",
"cryptography==45.0.4",
"distro==1.9.0",
"gidgethub==5.4.0",
"idna==3.10",
"pycparser==2.22",
"pyjwt==2.10.1",
"requests==2.32.4",
"typing-extensions==4.14.0",
"uritemplate==4.2.0",
"urllib3==1.26.20",
"zulip==0.9.0")

# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(
  envname = "bsklenv", packages = "python==3.9.22",
  pkgname = "BiocHail", pip = from_pinned
)
