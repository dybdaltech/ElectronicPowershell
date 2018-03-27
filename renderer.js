// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.
const $ = require('jquery');
const powershell = require('node-powershell');
const dt = require('datatables.net')();
const dtbs = require('datatables.net-bs4')(window, $);

let remote = require('electron').remote;

//Start:
$('document').ready(() => {
    $('#hideTableBtn').hide();
})

$("#getDisk").click( () => {
    let ps = new powershell({
        executionPolicy: 'Bypass',
        noProfile: true
    })
    let computer = $('#computerName').val() || 'localhost'
    console.log(computer);

    //Start the command with parameters
    ps.addCommand("./Drive-info", [
        { ComputerName: computer }
    ])

    ps.invoke()
    .then(output => {
        //Show the result:
        let data = JSON.parse(output)
        console.log(data)

        //Datatables
        let columns = [];
        Object.keys(data[0]).forEach( key => columns.push({ title: key, data: key}) )

        //Create HTML table
        $('#output').DataTable({
            data: data,
            columns: columns,
            paging: false,
            destroy: true
        });
        $('#hideTableBtn').show();
        $('#tableDiv').show();
    })
    .catch(err => {
        $('.alert-danger .message').html(err)
        $('.alert-danger').show()
        console.error(err);
        ps.dispose()
        
    })
});
$('#hideTableBtn').click(() => {
    $('#tableDiv').hide();
    $('#hideTableBtn').hide()
})

$('#rsatBtn').click(() => {
    let ps = new powershell({
        executionPolicy: 'Bypass',
        noProfile: true
    })

    let commands = [{ command: 1 }]
    let cred = remote.getGlobal('sharedObj').cred

    if(cred){
        commands.push({ JsonUser: JSON.stringify(cred)})
    }
    ps.addCommand("./RSAT")

    ps.invoke()
    .then((output) => {
        console.log(output)
    })
    .catch((err) => {
        console.error(err);
        ps.dispose();
    })
})

$('#credBtn').click(() => {
    let ps = new powershell({
        executionPolicy: 'Bypass',
        noProfile: true
    })

    ps.addCommand('./Convert-CredToJson')

    ps.invoke()
    .then(output => {
        console.log(output)
        remote.getGlobal('sharedObj').cred = JSON.parse(output)

        console.log(remote.getGlobal('sharedObj').cred)
    })
    .catch(err => {
        console.dir(err);
        ps.dispose();
    })
})



/*
        if(data.error) {
            $('.alert-danger .message').html(data.Error.Message)
            $('.alert-danger').show()
            return
        }
*/