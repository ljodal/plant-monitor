from time import sleep
from os import environ

import requests
import smbus


class Monitor():
    def __init__(self, bus=1, address=0x20):
        self.bus_num = bus
        self.address = address
        self.bus = smbus.SMBus(bus)

    @property
    def moisture(self):
        return self._get_reg(0)

    @property
    def temperature(self):
        return self._get_reg(5) / 10.0

    @property
    def light(self):
        self.bus.write_byte(self.address, 3)
        sleep(3)
        return self._get_reg(4)

    def reset(self):
        # To reset the sensor, write 6 to the device I2C address
        self.bus.write_byte(self.address, 6)

    def _get_reg(self, reg):
        # read 2 bytes from register
        val = self.bus.read_word_data(self.address, reg)
        # return swapped bytes (they come in wrong order)
        return (val >> 8) + ((val & 0xFF) << 8)


if __name__ == "__main__":
    m = Monitor()

    # Reset the senor first, to ensure we get correct readings
    m.reset()
    sleep(2)

    # Read metrics once before continuing
    m.temperature
    m.moisture

    # Get authentication information
    username = environ.get('USERNAME')
    if not username:
        raise ValueError('Missing username')

    password = environ.get('PASSWORD')
    if not password:
        raise ValueError('Missing password')

    auth = (username, password)

    # Get plant ID
    api_endpoint = environ.get('API_ENDPOINT')
    if not api_endpoint:
        raise ValueError('Missing api_endpoint')

    plant_id = environ.get('PLANT_ID')
    if not plant_id:
        raise ValueError('Missing plant_id')

    # Collect metrics
    data = [{
        'id': plant_id,
        'type': 'temp',
        'value': m.temperature,
    }, {
        'id': plant_id,
        'type': 'moisture',
        'value': m.moisture,
    }]

    # Report the metrics to the server
    response = requests.put(api_endpoint, auth=auth, json=data, timeout=10.0)

    if response.status_code != requests.codes.ok:
        print('Failed to submit metrics')
        print(response)
        print(response.headers)
        print(response.text)
    else:
        print('Metrics submitted successfully')
