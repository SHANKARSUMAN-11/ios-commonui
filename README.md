# iOS-CoreUI

The CoreUI is a config driven framework created to get started with any iOS application development with ease. 

# Integration Guidelines
Using Carthage :
`git "git@gitlab.com:coviam-mobile/ios-commonuisdk.git"`

>  Notes: Make sure you have setup ssh key for this private repository,
Add ssh using : ssh-add -K ~/.ssh/id_rsa

## Getting Started

These instructions will get you upto the speed of how the UI elements can be configured by using the json objects.

A sample JSON configuration is given below.

### CustomTextField

```
"TextField" : {
        "backgroundColor" : "#8bc63f",
        "textColor" : "#123456",
        "borderColor": "#8bc63f00",
        "separatorColor": "#ff0000",
        "separatorHeight": 2.0,
        "borderWidth": 1.0,
        "cornerRadius" : 5.0,
        "shadowWidth": 1.0,
        "placeholder": "Label Text",
        "placeholderTextColor": "#bdbdbd",
        "helperTextColor": "#bdbdbd"
}
```

This is a sample json to configure a UITextField. The TextField (with a separator at the bottom) is customised under the class CustomTextField.

Some important points to note down here are,

```
1. The colors should be given in hex code format
2. To make a transparent / clear color, append 00 at the end of the color code. Ex: "#ffffff00"
3. Any radius, width, height etc, to be given in Float rather than an Integer value
```

### CustomAlertViewController 
If there is only one action to be set, just set the leftButtonTitle to nil in the following API.
```
alert.createAlert(title: description: image: imagePosition: imageColor: statusViewColor:  rightButtonTitle: leftButtonTitle: nil)
```

### CustomButton
```
@IBInspectable var shapeType
```
The shapeType is an integer takes up the values from 0 to 2.
```
0 - Contained stype
1 - Outlined style
2 - Ghost style
```
# ios-commonui
