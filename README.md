# Group Project - ActivityFinder

ActivityFinder (temp name) is going to be an app  that helps indecisive individuals to pick activites while out with friends/family. Sometimes, we end up taking too much time to decide on what to do and this app will make it easier for people to decide an activity by generating an activity from user's lists, according to the user input of time, money, and distance/location. We are thinking of using the Yelp API to get general information and description of businesses/locations.

Time spent: **X** hours spent in total

## User Stories(required)
Individual:(user)
- [x] User can sign up and login (JJ)
- [x] User can retrieve their Lists of activities (getLists()-JJ and Justin, display lists- JJ, Melissa and Michelle)
- [x] User can create an activity List (Melissa and Michelle)
- [x] User can add Activity into a List (Melissa and Michelle)
- [x] Autocomplete functionality when user tries to create an activity - Michelle and Melissa
- [x] User can search for description from our app (which will integrate the Yelp database)-edit:making our own database, not using Yelp
- [x] User can edit information such as location, duration, cost, group size(big vs small group vs individual) (partially working) -Justin
- [x] User can like a List from different users(so lists are public, kinda like how spotify playlists are)
    -- [x]programmatically have a likecount for each list, and sort top 10 lists with highest like counts. -JJ (still working on display)
- [x] User can push a button to generate an (Random) activity from their List(s) - Melissa
- [x]User will have a profile with their list of activities(the activities they have done) and maybe even some friends list - Melissa and Michelle
- [x] Individual Explore: from top 10 lists with highest like counts - JJ
- [x] Individual Explore: from top 10 activities with highest like counts- JJ
- [x] Users can add a list they like into their own lists and edit that lists' contents. The activities of the liked list are also copied over - Melissa and Michelle
- [x] Alert controllers pop up to guide user in the right direction and stop them from creating another list with the same name as a list that is already in the database. - Melissa
- [x] options function on the home page to change cost, location, and type of activity -- mostly done -Justin 
- [x] incorporate tags for an activity (such as food, entertainment, music, etc) instead of long descriptions, since tags are faster to sort by - Melissa



## Optional user stories
- [x] User can change their password - Michelle
- [x] persistent login(so users don't have to login over and over again) - Michelle
- [-] User can like an Activity from his/her own List - working on it
- [-] User can edit activity description --working on it -Melissa
- [] User can use map to see their activities
- [] User can use camera to take picture of activities
- [-] User can choose between different random search modes: --working on it -Justin(options page)
- [] Users can see if their friends also plan on going to the same activity, so they can go together

## Database/ API
- API for activity description: Yelp
- Database: Parse


## Video Walkthrough

Here's a walkthrough of implemented user stories:


<img src='https://imgur.com/A6AihUh.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />





## older gifs:

<img src='https://i.imgur.com/CxcLl2k.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='https://imgur.com/IpnmRZz.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='https://imgur.com/x5uo2Dd.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='https://imgur.com/bo78ciz.png' title='Wireframes' width='' alt='Wireframes' />

<img src='https://i.imgur.com/OtpjVnb.png' title='Wireframes' width='' alt='Wireframes' />

<img src='https://i.imgur.com/jgSFbGv.png' title='Wireframes' width='' alt='Wireframes' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

Copyright [2018] [boredom]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
