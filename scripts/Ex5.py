import os
import sys
import subprocess

exes_wanted = ['transeq', 'getorf', 'patmatmotifs']
exes = {};
path = os.environ['EMBOSS_ROOT']

for name in exes_wanted:
    exes[name] = os.path.join(path, name + '.exe')

print('getorf')
cline = exes['getorf']
cline += ' -sequence data/sequence.fasta -outseq ex5_out/out.orf -minsize 600'

child = subprocess.Popen(str(cline),
                        stdin=subprocess.PIPE,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        universal_newlines=True,
                        shell=(sys.platform != "win32"))

child.wait()

print('patmatmotifs')
cline = exes['patmatmotifs']
cline += ' -sequence ex5_out/out.orf -outfile ex5_out/out.patmatmotifs'

child = subprocess.Popen(str(cline),
                        stdin=subprocess.PIPE,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        universal_newlines=True,
                        shell=(sys.platform != "win32"))

child.wait()

print('finished')
