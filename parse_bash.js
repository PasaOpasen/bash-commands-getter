
const parse = require('bash-parser');
const fs = require('fs')

const [ node, file, ...args ] = process.argv;
const path = args.join(' ');

// console.log(path)

fs.readFile(path, 'utf8', (err, inputD) => {
    if (err) throw err;
    // console.log(inputD.toString());

    fs.writeFile(
        "ast.json", 
        JSON.stringify(
            parse(inputD.toString(), {'mode': 'bash'})
        ), 
        'utf8', 
        function(err) {
            if (err) {
                console.log(err);
            }
        }
    );
})


