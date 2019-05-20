from flask import Flask, jsonify, abort
import code
import json
import requests
import os

app = Flask('swotdata_svr')

machine_ip = '128.119.82.236'
def get_ip_address(machine_ip):
    try:
        localhost = socket.gethostbyname(socket.gethostname())
    except:
        localhost = machine_ip
    return localhost

@app.route('/fetchdata/<int:number_of_files>', methods=['GET'])
def query_all_rivers(number_of_files):
    #path = '/home/amuhebwa/Documents/Python/SWOT_MISSION/Data/Pepsi1/Pepsi1'
    path = '/home/amuhebwa/Documents/R-Projects/swot_bams/data'
    netcdf_files = os.listdir(path)
    badfile=".DS_Store"
    if badfile in netcdf_files:
        netcdf_files.remove(badfile)

    if len(netcdf_files) == 0:
        return jsonify("No Available Datasets")
    else:
        netcdf_files.sort(key=lambda f: os.path.getctime('{}/{}'.format(path, f)))
        test_dict = {'file_names': netcdf_files}
        return jsonify(test_dict)

@app.route('/riverdata/<rivername>', methods=['GET'])
def query_single_river(rivername):
    path = './Pepsi1/Pepsi1'
    # StLawrenceDownstream.nc
    filepath = path + '/{}'.format(rivername)
    return jsonify(filepath)

if __name__ == '__main__':
    localhost = get_ip_address(machine_ip)
    app.run(host=localhost, port=42581, threaded=True)