/* jshint node: true */
'use strict';

var path = require('path'),
  spawn = require('child_process').spawn,
  RSVP = require('rsvp'),
  //fs = require('fs'),
  chalk = require('chalk'),
  isWin = /^win/.test(process.platform),
  gradlePathLinux = path.resolve('db-reverse-engineering', 'gradlew'),
  gradlePathWindows = path.resolve('db-reverse-engineering', 'gradlew.bat');

module.exports = {
  name: 'ember-aupac-db-reverse-engineering',
  includedCommands: function() {
    return {
      dbReverseEngineering: {
        name: 'db-reverse-engineer',
        aliases: ['db-rev-eng'],
        description: 'Reverse engineer your database; supported parameters are [emberData, emberCliMirage]',
        works: 'insideProject',
        runCommand: function(args) {
          return new RSVP.Promise(function (resolve, reject) {
            var child, result, options, i;

            console.log(chalk.green.bold('Reverse engineering your database...'));
            if(isWin) {
              options = ['/c', gradlePathWindows, '--project-dir=./db-reverse-engineering/'];
              for (i = 0; i < args.length; i++) {
                options.push(args[i]);
              }
              console.log(options);
              child = spawn('cmd.exe', options);
            } else {
              options = [gradlePathLinux, '--project-dir=./db-reverse-engineering/'];
              for (i = 0; i < args.length; i++) {
                options.push(args[i]);
              }
              child = spawn('bash', options);
            }

            result = {
              output: [],
              errors: [],
              code: null
            };

            child.stdout.on('data', function (data) {
              var string = data.toString();
              if (this.ui) {
                this.ui.writeLine(string);
              } else {
                console.log(string);
              }

              result.output.push(string);
            });

            child.stderr.on('data', function (data) {
              var string = data.toString();
              if (this.ui) {
                this.ui.writeLine(string);
              } else {
                console.error(string);
              }

              result.errors.push(string);
            });

            child.on('close', function (code) {
              result.code = code;

              if (code === 0) {
                console.log(chalk.green.bold('Reverse engineering complete!'));
                resolve(result);
              } else {
                reject(result);
              }
            });

          });
        },
        run: function (options, rawArgs) {
          return this.runCommand(rawArgs);
        }
      }
    }
  }
};
