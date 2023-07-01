import 'package:database/bloc/bloc/notes_bloc.dart';
import 'package:database/bloc/events/crud_events.dart';
import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/screens/Note_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:database/extensions/context_extensions.dart';

import '../bloc/states/crud_states.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
// NoteGetXController controller = Get.put<NoteGetXController>(NoteGetXController());
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<NotesBloc>(context).add(ReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                _showLogoutConfirmDialog(context);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoteScreen()));
              },
              icon: const Icon(Icons.note_add_outlined))
        ],
      ),
      body: BlocConsumer<NotesBloc,CrudState>(
        listenWhen: (previous,current )=> current is ProcessState && current.processType == ProcessType.delete,
        listener: (context ,state){
          state as ProcessState;
            context.showSnackBar(message: state.message , error: !state.status);
        },
        buildWhen: (previous , current)=> current is ReadState || current is LoadingState ,
        builder: (context , state){
          if(state is LoadingState){
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(state is ReadState && state.notes.isNotEmpty){
            return ListView.builder(
                            itemCount: state.notes.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: ()  {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NoteScreen(
                                            note: state.notes[index],
                                          )));

                                },
                                leading: const Icon(Icons.note),
                                title: Text(state.notes[index].title),
                                subtitle: Text(state.notes[index].info),
                                trailing: IconButton(
                                    onPressed: ()  {
                                     BlocProvider.of<NotesBloc>(context).add(DeleteEvent(index));
                                    },
                                    icon: const Icon(Icons.delete)),
                              );
                            });
          }
          else{
            return Center(child: Text(context.localizations.no_data , style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 30.sp,
              color: Colors.grey,
            ),),);
          }

        },
      ),
    );
  }

  }

  void _showLogoutConfirmDialog(BuildContext context) async {
    bool? result = await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(width: 1.w, color: Colors.pink.shade200)),
            backgroundColor: Colors.pink.shade100,
            title:  Text(context.localizations.confirm_logout),
            content:  Text(context.localizations.are_you_sure ),
            titleTextStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
            contentTextStyle: GoogleFonts.cairo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w300,
              height: 1.0,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    context.localizations.cancel,
                    style: GoogleFonts.cairo(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    SharedPrefController().clear();
                    Navigator.pop(context, true);
                    // Navigator.pushReplacementNamed(context, '/login_screen');
                  },
                  child: Text(
                    context.localizations.confirm,
                    style: GoogleFonts.cairo(color: Colors.blue),
                  ))
            ],
          );
        }

        );
    if (result ?? false) {
      bool cleared = await SharedPrefController().clear();
      if (cleared) {
        Navigator.pushReplacementNamed(context, '/Login');
      }
    }
  }


