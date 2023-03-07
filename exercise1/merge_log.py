import json

import time

import argparse

from datetime import datetime
from pathlib import Path

_OUTPUT_LOG_FILENAME = 'output.jsonl'
_TIMESTAMP_MASK = '%Y-%m-%d %H:%M:%S'


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Script for merging json logs')

    parser.add_argument(
        'path_log_a',
        metavar='<FIRST LOG PATH>',
        type=str,
        help='path to log_a',
    )

    parser.add_argument(
        'path_log_b',
        metavar='<SECOND LOG PATH>',
        type=str,
        help='path to log_b',
    )

    parser.add_argument(
        '-o',
        action='store',
        help='output dir for merged log',
        dest='output_dir',
    )

    return parser.parse_args()


def _create_dir(dir_path: Path) -> None:
    if dir_path.exists():
        raise FileExistsError(
            f'Dir "{dir_path}" already exists. Remove it first or choose another one.')

    dir_path.mkdir(parents=True)


def _validate_files(*args: Path) -> None:
    for file_path in args:
        if not file_path.is_file():
            raise FileNotFoundError(f"File <{file_path}> is directory or not exists. Please choose correct file path.")


def _merge_logs(path_a: Path, path_b: Path, output_file) -> None:
    print("Start merging...")
    with open(path_a, 'rb') as log_a, open(path_b, 'rb') as log_b, open(output_file, 'wb') as output:
        line_a, line_b = log_a.readline(), log_b.readline()

        while line_a and line_b:
            # TODO dry below
            dict_a, dict_b = json.loads(line_a), json.loads(line_b)
            timestamp_str_a, timestamp_str_b = dict_a.get("timestamp"), dict_b.get("timestamp")
            # TODO validating
            timestamp_a, timestamp_b = datetime.strptime(timestamp_str_a, _TIMESTAMP_MASK), datetime.strptime(timestamp_str_b, _TIMESTAMP_MASK)

            # TODO dry
            if timestamp_a <= timestamp_b:
                output.write(line_a)
                line_a = log_a.readline()
            else:
                output.write(line_b)
                line_b = log_b.readline()


        # TODO do explicit
        remain_log = log_a if line_a is not None else log_b
        output.write(remain_log.read())


def main():
    """
    > python3 log_generator.py ./logs
    > python3 merge_log.py logs/log_a.jsonl logs/log_b.jsonl -o result/
    """
    args = _parse_args()

    t0 = time.time()
    path_log_a, path_log_b = Path(args.path_log_a), Path(args.path_log_b)
    _validate_files(path_log_a, path_log_b)

    output_dir = Path(args.output_dir)
    output_file = output_dir.joinpath(_OUTPUT_LOG_FILENAME)
    _create_dir(output_dir)
    _merge_logs(path_log_a, path_log_b, output_file)

    # TODO После слияния сделать проверку на потерю данных: а + в = слитый файл
    print(f"finished in {time.time() - t0:0f} sec")


if __name__ == '__main__':
    main()
