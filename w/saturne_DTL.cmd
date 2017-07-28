REM NET TIME \\saturne /SET /YES
net use M: \\saturne\commun$ /user:info\DLT DLT /persistent:no
net use U: \\saturne\users$ /user:info\DLT DLT /persistent:no
net use H: \\saturne\oracle$ /user:info\DLT DLT /persistent:no
exit
