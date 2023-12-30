<cfheader name="cache-control" value="no-cache, no-store, must-revalidate"> 
<cfheader name="expires" value="-1"> 
<cfheader name="pragma" value="no-cache"> 
<cfhttp url="https://api.darksky.net/forecast/2566a05d0c6635ddc52b74ba848a65e0/42.1561,-93.2968" method="get" result="jsonData" />
<cfset weatherData = deserializeJson(jsonData.filecontent) />
<!doctype html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="x-ua-compatible" content="ie=edge" />
        <title>Weather</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!---<link href="https://fonts.googleapis.com/css?family=Lato:400,700" rel="stylesheet" />--->
        <link href="weather-icons.min.css" rel="stylesheet" />
        <style type="text/css">
            html, body, div, span, applet, object, iframe, h1, h2, h3, h4, h5, h6, p, blockquote, pre, a, abbr, acronym, address, big, cite, code, del, dfn, em, img, ins, kbd, q, s, samp, small, strike, strong, sub, sup, tt, var, b, u, i, center, dl, dt, dd, ol, ul, li, fieldset, form, label, legend, table, caption, tbody, tfoot, thead, tr, th, td, article, aside, canvas, details, embed, figure, figcaption, footer, header, hgroup, menu, nav, output, ruby, section, summary, time, mark, audio, video { margin: 0; padding: 0; border: 0; font-size: 100%; font: inherit; vertical-align: baseline; }
            body { background: #000000; font-family: 'Segoe UI', sans-serif; line-height: 1; overflow: hidden; }
            table { border-collapse: collapse; border-spacing: 0; }
           .weather { background: url('background-2022.jpg') no-repeat; color: #ffffff; width: 1920px; height: 787px; margin: 0 auto; }
           /*.weather .location { font-size: 48px; position: absolute; top: 200px; left: 50px; text-transform: uppercase; }*/
           .weather .icon { font-size: 220px; position: absolute; top: 70px; left: 50px; text-shadow: 4px 4px 5px rgba(0, 0, 0, 0.7); }
           .weather .temp { font-size: 220px; position: absolute; top: 45px; left: 350px; text-shadow: 4px 4px 5px rgba(0, 0, 0, 0.7); font-weight: 700; letter-spacing: -10px; }
           .weather .skies { font-size: 80px; position: absolute; top: 290px; left: 350px; text-shadow: 4px 4px 5px rgba(0, 0, 0, 0.7); font-weight: 500; }
           .weather .currents { font-size: 50px; position: absolute; top: 390px; left: 350px; text-shadow: 4px 4px 5px rgba(0, 0, 0, 0.7); }
           .weather .currents td { padding: 0 50px 15px 0; }
           .weather .currents tr td:last-child { text-transform: uppercase; }
           
           .weather .currents small { font-size: 75%; }
           .weather .forecast { position: absolute; top: 70px; left: 1050px; width: 800px; text-shadow: 4px 4px 5px rgba(0, 0, 0, 0.7); }
           .weather .forecast td { padding: 15px; font-size: 40px; vertical-align: middle; }
           .weather .forecast td.high { background-color:rgba(204, 0, 51, 0.4); text-align: center; }
           .weather .forecast td.low { background-color:rgba(0, 51, 204, 0.4); text-align: center; }
           .weather .forecast td.info { background-color:rgba(0, 0, 0, 0.5); font-size: 35px; width: 100%; }
           .weather .forecast td.spacer { height: 15px; padding: 0; }
           .weather .alert { position: absolute; top: 614px; left: 1050px; width: 770px; background-color:rgba(204, 0, 51, 0.9); font-size: 50px; padding: 15px; animation: blinker 2s linear infinite; }
           .weather .alert img { height: 50px; vertical-align: top; }
           @keyframes blinker { 50% { opacity: 0.5; } }
        </style>
    </head>
    <body>
        <cfoutput>
        <div class="weather">
            <cfset currently = weatherData["currently"] />
            <!---<div class="location">Zearing, Iowa</div>--->
            <em class="icon wi #getIconClass(currently["icon"])#"></em>
            <div class="temp">#int(currently["temperature"])#&deg;</div>
            <div class="skies">#currently["summary"]#</div>
            <table class="currents">
                <tr>
                    <td>Feels Like:</td>
                    <td>#int(currently["apparentTemperature"])#&deg;</td>
                </tr>
                <!---<tr>
                    <td>Dew Point:</td>
                    <td>#currently["dewPoint"]#&deg;</td>
                </tr>--->
                <tr>
                    <td>Humidity:</td>
                    <td>#val(currently["humidity"])*100#%</td>
                </tr>
                <tr>
                    <td>Wind:</td>
                    <td>#currently["windSpeed"]# <small>mph #getWindDirection(int(currently["windSpeed"]))#</small></td>
                </tr>
                <tr>
                    <td>Visibility:</td>
                    <td>#currently["visibility"]# <small>mi</small></td>
                </tr>
                <tr>
                    <td>Pressure:</td>
                    <td>#NumberFormat(val(currently["pressure"])*0.02953,".99")# <small>hg</small></td>
                </tr>
            </table>
            <table class="forecast">
                <cfloop from="1" to="5" index="i">
                    <cfset today = weatherData["daily"]["data"][i] />
                    <cfset date = dateAdd("s", val(today["time"]), createDateTime(1970, 1, 1, 0, 0, 0)) />
                    <tr>
                        <td class="info">#dateFormat(date, "ddd")#: #today["summary"]#</td>
                        <td class="high">#int(today["temperatureHigh"])#&deg;</td>
                        <td class="low">#int(today["temperatureLow"])#&deg;</td>
                    </tr> 
                    <tr>
                        <td colspan="3" class="spacer"></td>
                    </tr>
                </cfloop>
            </table>
            <cfif structKeyExists(weatherData, "alerts")>
                <div class="alert">
                    <img src="alert.png" alt="alert" />
                    #weatherData["alerts"][1]["title"]#
                </div>
            </cfif>
        </div>
        </cfoutput>
    </body>
</html>

<cfscript>
    function getIconClass(icon) {
        if (icon eq "clear-day") { return "wi-day-sunny"; }
        else if (icon eq "clear-night") { return "wi-night-clear"; }
        else if (icon eq "rain") { return "wi-rain"; }
        else if (icon eq "snow") { return "wi-snow"; }
        else if (icon eq "sleet") { return "wi-sleet"; }
        else if (icon eq "wind") { return "wi-strong-wind"; }
        else if (icon eq "fog") { return "wi-day-fog"; }
        else if (icon eq "cloudy") { return "wi-cloud"; }
        else if (icon eq "partly-cloudy-day") { return "wi-day-cloudy"; }
        else if (icon eq "partly-cloudy-night") { return "wi-night-alt-cloudy"; }
        else if (icon eq "hail") { return "wi-hail"; }
        else if (icon eq "thunderstorm") { return "wi-thunderstorm"; }
        else if (icon eq "tornado") { return "wi-tornado"; }
        else { return "wi-na"; }
    }

    function getWindDirection(bearing) {
        if (bearing gte 11 and bearing lt 34) { return "NNE"; }
        else if (bearing gte 34 and bearing lt 56) { return "NE"; }
        else if (bearing gte 56 and bearing lt 79) { return "ENE"; }
        else if (bearing gte 79 and bearing lt 101) { return "ENE"; }
        else if (bearing gte 101 and bearing lt 124) { return "ESE"; }
        else if (bearing gte 124 and bearing lt 146) { return "SE"; }
        else if (bearing gte 146 and bearing lt 169) { return "SSE"; }
        else if (bearing gte 169 and bearing lt 191) { return "S"; }
        else if (bearing gte 191 and bearing lt 214) { return "SSW"; }
        else if (bearing gte 214 and bearing lt 236) { return "SW"; }
        else if (bearing gte 236 and bearing lt 259) { return "WSW"; }
        else if (bearing gte 259 and bearing lt 281) { return "W"; }
        else if (bearing gte 281 and bearing lt 304) { return "WNW"; }
        else if (bearing gte 304 and bearing lt 326) { return "NW"; }
        else if (bearing gte 326 and bearing lt 348) { return "NNW"; }
        else { return "N"; }
    }
</cfscript>