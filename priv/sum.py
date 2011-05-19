import sys
import csv
import re
import os
#    print lat

import Gnuplot

c = re.compile(r"^{concurrent, ")
def get_concurrency(dir):
    try:
        f = open("%s/msgpack.config" % dir)
        conc = 0
        for line in f.readlines():
            m = c.match(line)
            if m is not None:
                conc = int(line[m.end():-3])
        return conc
    except:
        f = open("%s/thrift.config" % dir)
        conc = 0
        for line in f.readlines():
            m = c.match(line)
            if m is not None:
                conc = int(line[m.end():-3])
        return conc

def get_nums(dir):
    summary = csv.reader(open("%s/summary.csv"%dir))
    summary.next()
    n = 0
    sum = 0
    elapsed = 0
    for row in summary:
        n += 1
        elapsed = float(row[0])
        sum += int(row[2])

    thruput = sum / elapsed
#    print "thruput: %f" % thruput

    lat = csv.reader(open("%s/put_latencies.csv"%dir))
    lat.next()
    n = 0
    sum = 0.0
    elapsed = 0
    for row in lat:
        n += int(row[2])
        elapsed = float(row[0])
        sum += float(row[4]) * int(row[2])
    ave_latency = sum / n
#    print "latency: %f" % ave_latency
    return (get_concurrency(dir), thruput, ave_latency)

def analyze_dir(dir):
    return get_nums(dir)

#dir = sys.argv[1]
#print analyze_dir(dir)
dirs = ['cpp-srv', 'erlang-srv', 'ruby-srv', 'thrift']

gp = Gnuplot.Gnuplot()

gp('set terminal postscript enhanced')
gp('set output "chaos.eps"')
gp.title("Throughput graph")
#gp('set xtics 10')
gp('set logscale x')
gp.xlabel("client concurrency")
gp.ylabel("Throughput [RPCs/sec]")
gp('set style data lines')
gp('set xrange [8:12000]')
#gp('help set')
#gp('set style line 1 lt 2 lw 4')
gp('set grid')

pp = []
for dir in dirs:
    th = []
    for d in os.listdir(dir):
        t = analyze_dir('/'.join([dir,d]))
#        print c,t,l
        th.append((t[0], t[1]))
#        print dir,t
    th.sort(key=lambda x: x[0])
    print dir, th
    p = Gnuplot.PlotItems.Data(th, title=dir)
#    p = Gnuplot.PlotItems.PlotItem() #, title=dir)
    pp.append(p)
    #gp.plot(p)
    #break
gp.plot(*pp)
#gp.plot(p)
