const express  = require('express');
const util     = require('util')
var path       = require("path");
var bodyParser = require('body-parser');
var hbs        = require('express-handlebars');
var app        = express();


///////////////////////////////////
// configuring the server
app.engine('hbs', hbs({extname: 'hbs', layoutsDir:__dirname + '/views'}));
app.set('view engine', 'hbs')
app.use(express.static('html'));
app.use(bodyParser());


///////////////////////////////////
//variables for the database
var login;
var profiling;
var db_trials = new Array();
var questionnaire;
var NUMBER_OF_TRANNING_TRIALS = 2;
var NUMBER_OF_VALID_TRIALS = 6;
var NUMBER_OF_VIDEOS = 6;
//var CHOSEN_EXAMPLE = 'backward_ramp';
var CHOSEN_EXAMPLE = 'click_backward_forwards_ramp';

//////////////////////////////////
//setting up the server
app.listen(3000, function () {
  console.log('Example app listening on port 3000!')
})

//////////////////////////////////
//callbacks for the webpages
app.get('/', function (req, res) {
  res.sendFile(path.join(__dirname+'/html/index.html'));
});

app.post('/introduction', function (req, res) {
  login = req.body;
  login.beginTimestamp = timestamp();

  console.log('##################');
  console.log('##################');
  console.log('starting new section');
  console.log('id: ' + login.id);
  console.log('timestamp: ' + util.inspect(login.beginTimestamp, false, null));

  res.sendFile(path.join(__dirname+'/html/introduction.html'));

  init_presentation_order();
});


app.get('/profiling', function (req, res) {
  res.sendFile(path.join(__dirname+'/html/profiling.html'));
});

app.post('/instructions', function (req, res) {
  readingAllPossibleTrials();

  profiling = req.body;

  if (typeof profiling.language == "undefined")
      profiling.language = "None";
  if (profiling.language=="another")
      profiling.language = profiling.extralanguage;

  delete profiling.extralanguage;
  /*
  //looks for the void "" language
  voidLanguageIndex = profiling.languages.indexOf("");
  //if languages includes the void "" language
  if (voidLanguageIndex>0)
    //removes it
    profiling.languages.splice(voidLanguageIndex, 1)
  */

  console.log('gender: ' + profiling.gender);
  console.log('age: ' + profiling.age);
  console.log('experience: ' + profiling.experience);
  console.log('language: ' + profiling.language);

  current_block = 0;
  max_blocks    = 3;
  delete context;

  res.render('instructions', {
      maxtrials: NUMBER_OF_VALID_TRIALS,
      numVideos: NUMBER_OF_VIDEOS,
  });
  //res.sendFile(path.join(__dirname+'/html/instructions.html'));
});

app.get('/important', function (req, res) {
  res.sendFile(path.join(__dirname+'/html/important.html'));
});



app.get('/block', function (req, res) {
  refreshTrials();

  if (current_block >= max_blocks )
    res.sendFile(path.join(__dirname+'/html/finalquestionnaire.html'));
  else {
    var context = generate_context_for_current_block();
    res.render('block', context);
  }
});

app.get('/training', function (req, res) {
  current_trial = 0;
  max_trials = NUMBER_OF_TRANNING_TRIALS; //training trials
  is_collecting_data = false;
  console.log('\n');
  console.log('trainning...');
  res.sendFile(path.join(__dirname+'/html/training.html'));
});

//this is called the first time inside a block
app.get('/options', function (req, res) {
  //if this guy is null
  if (typeof context=='undefined') {
    context = generate_context_for_current_trial();
    //this is causing the bug!
    current_trial++;
  }
  res.render('options', context);
});

//gets called whenever there are results
app.post('/options', function (req, res) {
  var answers = req.body;
  process_answers(answers);

  if (current_trial >= max_trials ) { //checks if we are done ...
    //context = undefined;
    delete context;
    if (!is_collecting_data) { //in case we're done only with trainning, go to real trials
      current_trial = 0;
      max_trials = NUMBER_OF_VALID_TRIALS; //data colection trials
      is_collecting_data = true;
      console.log('\n');
      console.log('collecting data...');
      res.sendFile(path.join(__dirname+'/html/trials.html'));
    } else { //in case we're done for real, go to pause
      current_block++;
      //res.sendFile(path.join(__dirname+'/html/pause.html'));
      message = generate_pause_message();
      res.render('pause', message);
    }

  } else { //if we're not done yet
    context = generate_context_for_current_trial();
    res.render('options', context);
    current_trial++;
  }
});

app.post('/end', function (req, res) {
  questionnaire = req.body;
  console.log('easier: ' + questionnaire.easier);
  console.log('why easier? ' + questionnaire.easierwhy);
  console.log('harder: ' + questionnaire.harder);
  console.log('why harder: ' + questionnaire.harderwhy);

  saveData();

  res.sendFile(path.join(__dirname+'/html/end.html'));
});


//////////////////////////////////
//gfunction that processes answers
function process_answers(answer) {
  answer.block          = get_block_category_and_width().category;
  answer.trial          = current_trial;

  //remove what is not necessary
  delete answer.scenario;
  ///including login info
  answer.id             = login.id;
  answer.beginTimestamp = login.beginTimestamp;
  answer.endTimestamp   = login.endTimestamp;
  //including profiling
  answer.age            = parseInt(profiling.age);
  answer.experience     = parseInt(profiling.experience);
  answer.gender         = profiling.gender;
  answer.language        = profiling.language;
  //converting to the right type
  answer.videotime      = parseFloat(answer.videotime);
  answer.durationtime   = parseFloat(answer.durationtime);
  answer.presentationOrder = po_current;

  console.log(current_trial);
  console.log('selected_answer: ' + answer.selectedanswer);
  console.log('right_answer: ' + answer.rightanswer);
  console.log('video_time: ' + answer.videotime);
  console.log('duration_time: ' + answer.durationtime);

  if (is_collecting_data)
    db_trials.push(answer);
}

//////////////////////////////////
//generate unique timestamp
function timestamp() {
  var date = new Date();

  /*
  var text = date.getYear() + '-' + date.getMonth() + '-' + date.getDate()
  var components = {
      year: date.getYear(),
      month: date.getMonth(),
      data: date.getDate(),
      hour: date.getHours(),
      minute: date.getMinutes(),
      second: date.getSeconds(),
      miliSecond: date.getMilliseconds()
  };
  return components;
  */

  var text=date.toISOString().
                replace(/T/, ' ').      // replace T with a space
                replace(/\..+/, '');

  return text;
}


////////////////////////////////////////////////
//dealing with presentation possibilities for counterbalancement
var po_all_possibilities = [
    "ABC",
    "ACB",
    "BAC",
    "BCA",
    "CAB",
    "CBA"
];

//stores the current presentation order
var po_current;

//stores the current block inside the current presentation order
var current_block;

//initalizing the exp
function init_presentation_order() {
  //po_current    = po_all_possibilities[po_next_index];
  //po_next_index = (po_next_index+1)%po_all_possibilities.length;
  index = countUserFiles()%po_all_possibilities.length;
  po_current = po_all_possibilities[index];
  console.log("presentation order: " + po_current);
}

function get_block_category_and_width() {
  var option  = po_current.charAt(current_block);

  if (option=="A") {
    width = "60%";
    category = 'zen';
  }

  if (option=="B") {
    width = "60%";
    category = 'pd';
  }

  if (option=="C") {
    width = "75%";
    category = 'pde';
  }

  return {
    category: category,
    width: width
  };
}

function add_type(context) {
  var option  = po_current.charAt(current_block);

  if (option=="A")  context.zen="1";
  if (option=="B")  context.pd="1";
  if (option=="C")  context.pde="1";

  return context;
}

//functions for counterbalancing the blocks order
function generate_context_for_current_block() {

  var block = get_block_category_and_width();
  console.log('##################');
  console.log('starting ' + block.category + ' block');
  var context = {
    currentblock: (current_block+1),
    maxblock: max_blocks,
    //imagePath: 'scenarios/multimedia/bb_tasks/backward_ramp/backward_ramp.'+block.category+".jpg",
    //videoPath: 'scenarios/multimedia/bb_tasks/backward_ramp/backward_ramp.mp4',
    imagePath: 'scenarios/multimedia/one_input/' + CHOSEN_EXAMPLE + '/' + CHOSEN_EXAMPLE + '.' +block.category+".jpg",
    videoPath: 'scenarios/multimedia/one_input/' + CHOSEN_EXAMPLE + '/' + CHOSEN_EXAMPLE + '.mp4',
    width: block.width,
  };

  context = add_type(context);

  return context;
}

//function that generates the message for the "pause" page
function generate_pause_message() {

  if (current_block >= max_blocks)
  text = "You are now almost done. You can take a small break before proceeding to the final questionnaire. ";
  else
  text = "You can take a 5 minutes break before proceeding to the next block.";

  return {
    message: text,
  };
}

////////////////////////////////////
//dealling with the trials
var all_trials;
var unused_trials;
//var preselected_trials;
var who_is_current_trial;

// function that helps filtering hidden files
function filteringHiddenFiles(item) {
  //if it's a hidden file
  //or if'ts the CHOSEN_EXAMPLE used to introduce the block
  //return (item.charAt(0)!='.' && !(item.indexOf("backward_ramp")>=0));
  return (item.charAt(0)!='.' && !(item.indexOf(CHOSEN_EXAMPLE)>=0));
}

readingAllPossibleTrials();
readingAllPossibleTrials

//function for reading all trials from file
function readingAllPossibleTrials() {

  var fs = require('fs');
  var basepath = './html/scenarios/multimedia/';
  all_trials = new Array(0);

  result1 = fs.readdirSync(basepath+'bb_tasks/');
  result2 = fs.readdirSync(basepath+'one_input/');
  result3 = fs.readdirSync(basepath+'multimodal_input/');

  result1 = result1.filter(filteringHiddenFiles);
  result2 = result2.filter(filteringHiddenFiles);
  result3 = result3.filter(filteringHiddenFiles);

  for (i = 0; i < result1.length; i++)
    result1[i]= {
      type: 'bb_tasks',
      filename: result1[i]
    }

  for (i = 0; i < result2.length; i++)
    result2[i]= {
      type: 'one_input',
      filename: result2[i]
    }

  for (i = 0; i < result3.length; i++)
    result3[i]= {
      type: 'multimodal_input',
      filename: result3[i]
    }

  all_trials = result1.concat(result2, result3);
  preselectTrials();
  refreshTrials();
  //console.log(all_trials);
  //console.log(unused_trials);
}

function refreshTrials() {
  console.log('refreshing all trials...');
  i = all_trials.length;
  unused_trials = Array(i);
  while(i--) unused_trials[i]=all_trials[i];
}

function preselectTrials() {
  var quantity = NUMBER_OF_TRANNING_TRIALS + NUMBER_OF_VALID_TRIALS;
  //6 is the minimum number of scenarios to be loaded because of the videos
  if (quantity < 6)
    quantity = 6;
  console.log('selecting ' + quantity + ' scenarios');
  //shuffling the array
  all_trials = shuffle(all_trials);
  //selecting the right quantity of videos
  all_trials = all_trials.slice(0, quantity);
  console.log('selected scenarios:');
  console.log(all_trials);
  console.log('##################');
}

//function that defines the next unused random trial
function nextRandomTrial() {
  var index = Math.floor((Math.random() * unused_trials.length));
  who_is_current_trial = unused_trials[index];
  unused_trials.splice(index, 1);

  if (typeof who_is_current_trial=='undefined') {
    debugger;
    console.log("hey, bug!");
    console.log('unused_trials: ' + unused_trials);
    console.log('size: ' + unused_trials.length);
    console.log('index: ' + index);
  }

  return who_is_current_trial;
}

//generates 6 option trials containing 8 unique random ones and 1 right. the unique random ones need to be different from the right
function allOptions() {
  //copying the array
  i = all_trials.length;
  copy = Array(i);
  while(i--) copy[i]=all_trials[i];

  //creates the result array
  result = Array(NUMBER_OF_VIDEOS);

  //adding who_is_current_trial in the first position
  index = copy.indexOf(who_is_current_trial);
  result[0] = copy[index];
  copy.splice(index, 1);

  //fills the rest of the result array
  for (i=1; i < result.length; i++) {
    var index = Math.floor((Math.random() * copy.length));
    //console.log('index: ' + index);
    //console.log('copy.length: ' + copy.length);
    result[i] = copy[index];
    copy.splice(index, 1);
  }

  //returns random array
  return shuffle(result);
}

//fisher-yeates shiffle. code from: https://bost.ocks.org/mike/shuffle/
function shuffle(array) {
  var m = array.length, t, i;

  // While there remain elements to shuffle…
  while (m) {

    // Pick a remaining element…
    i = Math.floor(Math.random() * m--);

    // And swap it with the current element.
    t = array[m];
    array[m] = array[i];
    array[i] = t;
  }

  return array;
}

//generates the context for rendering the html for the current trial
function generate_context_for_current_trial() {
  who_is_current_trial = nextRandomTrial();
  //options              = nineOptions();
  options              = allOptions();
  block                = get_block_category_and_width();

  /*
  console.log(current_trial);
  console.log(max_trials);
  console.log(who_is_current_trial);
  console.log('options')
  console.log(options);
  console.log('options[0]');
  console.log(options[0]);
  console.log('options[1]');
  console.log(options[1]);
  console.log('options[2]');
  console.log(options[2]);
  */

  var context = {
    currenttrial: (current_trial+1),
    maxtrials: max_trials,
    imagePath: 'scenarios/multimedia/' + who_is_current_trial.type + '/' + who_is_current_trial.filename + '/' + who_is_current_trial.filename + '.' + block.category + ".jpg",
    videoASource: 'scenarios/multimedia/' + options[0].type + '/' + options[0].filename + '/' + options[0].filename + ".mp4",
    videoBSource: 'scenarios/multimedia/' + options[1].type + '/' + options[1].filename + '/' + options[1].filename + ".mp4",
    videoCSource: 'scenarios/multimedia/' + options[2].type + '/' + options[2].filename + '/' + options[2].filename + ".mp4",
    videoDSource: 'scenarios/multimedia/' + options[3].type + '/' + options[3].filename + '/' + options[3].filename + ".mp4",
    videoESource: 'scenarios/multimedia/' + options[4].type + '/' + options[4].filename + '/' + options[4].filename + ".mp4",
    videoFSource: 'scenarios/multimedia/' + options[5].type + '/' + options[5].filename + '/' + options[5].filename + ".mp4",
    //videoGSource: 'scenarios/multimedia/' + options[6].type + '/' + options[6].filename + '/' + options[6].filename + ".mp4",
    //videoHSource: 'scenarios/multimedia/' + options[7].type + '/' + options[7].filename + '/' + options[7].filename + ".mp4",
    //videoISource: 'scenarios/multimedia/' + options[8].type + '/' + options[8].filename + '/' + options[8].filename + ".mp4",
    videoAName: options[0].filename,
    videoBName: options[1].filename,
    videoCName: options[2].filename,
    videoDName: options[3].filename,
    videoEName: options[4].filename,
    videoFName: options[5].filename,
    //videoGName: options[6].filename,
    //videoHName: options[7].filename,
    //videoIName: options[8].filename,
    width: block.width,
    rightAnswer: who_is_current_trial.filename,
  };

  return context;
}

///////////////////////////////////////
// formating the experiment data to be saved in the db
function saveData() {
  //console.log("login: " + login);
  //console.log("profiling: " + profiling);
  //console.log("db_trials: " + db_trials);
  //console.log("questionnaire: " + questionnaire);

  /*
  data =  {
    login: login,
    profiling: profiling,
    db_trials: db_trials,
    questionnaire:questionnaire,
  }*/
  endTimestamp = timestamp();

  for (i = 0; i < db_trials.length; i++ ) {
    var item = db_trials[i];
    item.easier    = questionnaire.easier;
    item.easierwhy = questionnaire.easierwhy;
    item.harder    = questionnaire.harder;
    item.harderwhy = questionnaire.harderwhy;
    item.endTimestamp=endTimestamp;
  }

  jsondata = JSON.stringify(db_trials);

  console.log('##################');
  console.log('saving data...');
  console.log(jsondata);
  saveJson(jsondata);
}


var dbpath = './data/';
/*
var test=[{'a':1}, {'a':2}]
var a= JSON.stringify(test)
console.log(a);
saveJson(a)
*/

function saveJson(file) {

  const fs = require('fs');
  numFiles = countUserFiles();
  fs.writeFile(dbpath+'user'+numFiles+'.json', file, 'utf8', function (err) {
    if (err)
      return console.log(err);
    console.log("The file was saved!");
  });
}

function countUserFiles() {
  const fs = require('fs');
  result = fs.readdirSync(dbpath);
  return result.length;
}
