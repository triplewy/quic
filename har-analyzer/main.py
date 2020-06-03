import os
import json
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

from datetime import datetime, timedelta
from pathlib import Path
from operator import itemgetter
from termcolor import colored

ISO_8601_FORMAT = '%Y-%m-%dT%H:%M:%S.%fZ'

# http://www.softwareishard.com/blog/har-12-spec/#timings


def plot(title: str, page: str, entries: object):
    entries.sort(key=lambda x: x['startedDateTime'])
    size = page.split('/')[-2]
    numObjects = page.split('/')[-1].split('.')[0].split('-')[-1]

    start_time = datetime.strptime(
        entries[0]['startedDateTime'], ISO_8601_FORMAT)

    captions = list(map(lambda x: x['request']['url'].split('/')[-1], entries))
    captions.insert(0, '')

    fig = plt.figure()
    plt.title(title)
    plt.yticks(np.arange(len(entries) + 1), captions)
    plt.ylim(0, len(entries) + 1)

    if size == '10kb':
        if numObjects == '10':
            plt.xlim(0, 1500)
        elif numObjects == '100':
            plt.xlim(0, 5000)
    elif size == '100kb':
        if numObjects == '10':
            plt.xlim(0, 5000)
        elif numObjects == '100':
            plt.xlim(0, 15000)

    plt.autoscale(False)
    plt.xlabel('Time (ms)')
    plt.legend(handles=[
        mpatches.Patch(color='green', label='connect'),
        mpatches.Patch(color='cyan', label='send'),
        mpatches.Patch(color='yellow', label='wait'),
        mpatches.Patch(color='magenta', label='receive')
    ])

    for i, entry in enumerate(entries):
        start = datetime.strptime(
            entry['startedDateTime'], ISO_8601_FORMAT)
        end = start + timedelta(milliseconds=entry['time'])
        connect, send, wait, receive, = itemgetter(
            'connect', 'send', 'wait', 'receive')(entry['timings'])

        y = i + 1
        xstart = (start - start_time) / timedelta(milliseconds=1)
        xstop = (end - start_time) / timedelta(milliseconds=1)

        # Total time
        plt.hlines(y, xstart, xstop, 'r', lw=4)
        # line_height = len(entries) / 40
        # plt.vlines(xstart, y+line_height, y-line_height, 'k', lw=2)
        # plt.vlines(xstop, y+line_height, y-line_height, 'k', lw=2)

        # Connect time: green
        if connect != -1:
            plt.hlines(y, xstart, xstart + connect, 'g', lw=4)
            xstart += connect

        # Send time: cyan
        plt.hlines(y, xstart, xstart + send, 'c', lw=4)
        xstart += send

        # Wait time: yellow
        plt.hlines(y, xstart, xstart + wait, 'y', lw=4)
        xstart += wait

        # Receive time: magenta
        plt.hlines(y, xstart, xstart + receive, 'm', lw=4)
        xstart += receive

    # plt.show()
    graph_dir = Path.joinpath(
        Path.home(), 'quic', 'graphs', size, numObjects, title)
    Path(graph_dir).mkdir(parents=True, exist_ok=True)

    graph_file = Path.joinpath(graph_dir, 'graph.png')
    if os.path.isfile(graph_file):
        os.remove(graph_file)

    fig.savefig(graph_file, dpi=fig.dpi)


def main():
    object_sizes = ['10kb', '100kb']
    num_objects = ['10', '100']
    servers = ['chromium', 'http2', 'proxygen', 'quiche']
    har_dir = Path.joinpath(Path.home(), 'quic', 'chrome', 'har')

    for size in object_sizes:
        for server in servers:
            for num in num_objects:
                filename = Path.joinpath(
                    har_dir, size, server, "index-{}.har".format(num))

                with open(filename) as f:
                    data = json.load(f)
                    page = data['log']['pages'][0]['title']
                    entries = data['log']['entries']
                    entries.sort(key=lambda x: x['startedDateTime'])

                    start_time = datetime.strptime(
                        entries[0]['startedDateTime'], ISO_8601_FORMAT)

                    end_time = datetime.strptime(
                        entries[-1]['startedDateTime'], ISO_8601_FORMAT)
                    end_time += timedelta(milliseconds=entries[-1]['time'])

                    total_time = end_time - start_time
                    print(colored("Filename: {}, Total time: {} ms".format(filename,
                                                                           total_time / timedelta(milliseconds=1)), "green"))

                    plot(server, page, entries)


if __name__ == "__main__":
    main()
