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
    ave_latency = sum / n / 1000.0 # usec => msec
#    print "latency: %f" % ave_latency
    return (get_concurrency(dir), thruput, ave_latency)

def analyze_dir(dir):
    return get_nums(dir)

#dir = sys.argv[1]
#print analyze_dir(dir)
dirs = ['cpp-srv', 'erlang-srv', 'ruby-srv', 'thrift']

def get_gp(filename):
    _gp = Gnuplot.Gnuplot()
    _gp('set terminal postscript enhanced')
    _gp('set output "%s"' % filename)
#gp('set xtics 10')
    _gp('set logscale x')
    _gp.xlabel("client concurrency")
    _gp('set style data lines')
    _gp('set xrange [8:12000]')
#gp('help set')
#gp('set style line 1 lt 2 lw 4')
    _gp('set grid')
    return _gp

gp = get_gp("thruput.eps")
gp2 = get_gp("latency.eps")

gp.title("Average Throughput graph")
gp.ylabel("Average Throughput [RPCs/sec]")
gp2.title("Average Latency graph")
gp2.ylabel("Average Latency [msec]")
gp2('set logscale y')

th_ps = []
lat_ps = []
for dir in dirs:
    th = []
    lat = []
    for d in os.listdir(dir):
        t = analyze_dir('/'.join([dir,d]))
#        print c,t,l
        th.append((t[0], t[1]))
        lat.append((t[0], t[2]))
#        print dir,t
    th.sort(key=lambda x: x[0])
    lat.sort()
    print dir, th, lat
    th_ps.append( Gnuplot.PlotItems.Data(th, title=dir) )
    lat_ps.append( Gnuplot.PlotItems.Data(lat, title=dir) )
    #gp.plot(p)
    #break
gp.plot(*th_ps)
gp2.plot(*lat_ps)
#gp.plot(p)
