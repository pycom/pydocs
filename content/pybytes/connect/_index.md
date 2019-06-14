---
title: "Add a device to Pybytes"
aliases:
---

In this section, we will explain to you how to add a device to Pybytes

## Step 1: Add device wizard

In Pybytes, go to *Devices* Page:

1. Click on *Add Device*.

![](/gitbook/assets/1-1.jpg)

2. Select your device (e.g., WiPy, LoPy, SiPy, etc.);

![](/gitbook/assets/2-1.jpg)

4. Select your network option;

![](/gitbook/assets/pybytes/add-device/network-step.png)

5. Enter a unique name and the network credentials (SSID and password) for your device;

![](/gitbook/assets/5-1.jpg)

## Step 2: Connect your device to Pybytes

At the end of the "Add Device" wizard, Pybytes will show that your device profile was successfully created.

![](/gitbook/assets/pybytes/add-device/final-step.png)

Select how you would like to connect your device to Pybytes:

1. [Connect your device quickly (Recommended)](quick)

{{% refname "quick.md" %}}

2. [Connect your device by flashing Pybytes Library](flash)

{{% refname "flash.md" %}}

{{% hint style="info" %}}
From firmware 1.16.x onwards all Pycom devices come with Pybytes library built-in `/frozen` folder. That means that you can choose between adding your device quickly with the firmware updater or you can flash Pybytes library manually.
{{< /hint >}}
