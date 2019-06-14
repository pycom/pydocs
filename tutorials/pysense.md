# Pysense Examples

## Accelerometer

This basic example shows how to read pitch and roll from the on-board accelerometer and output it in comma separated value \(CSV\) format over serial.

```python
import time
from LIS2HH12 import LIS2HH12
# Depends on pycocrop.py from:https://github.com/pycom/pycom-libraries
from pysense import Pysense
py = Pysense()
acc = LIS2HH12()

while True:
   pitch = acc.pitch()
   roll = acc.roll()
   print('{},{}'.format(pitch, roll))
   time.sleep_ms(100)
```

![](../.gitbook/assets/accelerometer_visualiser%20%281%29.png)

If you want to visualise the data output by this script a Processing sketch is available [here](https://github.com/pycom/pycom-libraries/tree/master/examples/pytrack_pysense_accelerometer) that will show the board orientation in 3D.

